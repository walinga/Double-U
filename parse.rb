require_relative 'list-impl'
require_relative 'num-impl'
require_relative 'no-arg-impl'

class DoubleUError < Exception
end

class Main

  def initialize(src)
    @src = src
    @list = ListImpl.new
    @num = NumImpl.new
    @noarg = NoArgImpl.new
    @vars = {} # Hash table of variables
    @linenum = 1 # variable; used for error messages
  end

  def error(string)
    raise DoubleUError, "Double-u syntax error: #{string}. (line #{@linenum})"
  end

  def num_regex
    /\d+((\.|\/)\d+)?/
  end

  def array_regex
    /\[ *((#{num_regex} +)*#{num_regex}?)\]/
  end

  def to_num(s)
    (s.include? '.') ? s.to_f : @list.r2n(s.to_r)
  end

  def to_list(s)
    s.split.map { |x| to_num(x) }
  end

  def check_def(var)
    error "Variable #{var} undeclared" unless @vars.has_key?(var)
  end

  def find_type(var, func)
    if var.kind_of?(Array)
      @list
    elsif var.kind_of?(Numeric)
      @num
    else
      error "Invalid argument to function #{func}"
    end
  end

  def call_function(name, input)
    find_type(input, name).send("Impl_#{name}" ,input)
  end

  def merge(k1, k2)
    check_def(k1)
    check_def(k2)
    v1, v2 = @vars[k1], @vars[k2]
    if find_type(v1, "merge") != find_type(v2,"merge")
      error "Type inputs to merge don't match"
    end
    v1 + v2
  end

  def execline(inst)
    case inst.strip.downcase
    when /^$/  # Blank space
    when /^;.*$/ # Comment
    when /^(.*?);.*$/
      execline($1.strip)
    when /^\((.*)\)$/
      execline($1.strip)
    when /^let +(\w+) *= *#{array_regex}$/
      @vars[$1] = to_list($2)
    when /^let +(\w+) *= *(#{num_regex})$/
      @vars[$1] = to_num($2)
    # Expression as rvalue for 'let'
    when /^let +(\w+) *= *(.*)$/
      val = execline($2)
      error "trying to assign void to a variable" if val.nil?
      @vars[$1] = val
    # Note: printing literals is prohibited
    when /^print +(\w+)$/
      check_def($1)
      print @vars[$1], "\n"
    when /^print +(.*)$/
      val = execline($1)
      error "trying to print void" if val.nil?
      print val, "\n"
    when /^merge +(\w+) (\w+)$/
      merge($1, $2)
    # Num function with literal as param
    when /^([a-z]+)! *(#{num_regex})$/
      @num.send("Impl_#{$1}", to_num($2))
    # Any function with variable as param
    when /^([a-z]+)! +(\w+)$/
      check_def($2)
      call_function($1, @vars[$2])
    # List function with literal as param
    when /^([a-z]+)! *#{array_regex}$/
      @list.send("Impl_#{$1}", to_list($2))
    # No arg function
    when /^([a-z]+)!$/
      @noarg.send("Impl_#{$1}")
    # Any function with result of another function as param
    when /^([a-z]+)! +(.*)$/
      call_function($1, execline($2))
    # Just a literal var. Allows "let x = y"
    when /^(\w+)$/
      check_def($1)
      @vars[$1]
    else
      error "Invalid instruction"
    end
  rescue NoMethodError => e
    error e.message.split("\n").first.gsub(/#<(\w+).*>/, 'type \1').gsub(/Impl_?/, '')
  end

  def run
    if @src[0] == '`'
      print @src[1..-1]
      exit
    end

    # Since Double-U is a command-based language, we parse each line separately
    @src.split("\n").each do |inst|
      execline inst
      @linenum += 1
    end

  end
end
