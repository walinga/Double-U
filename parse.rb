require_relative 'list-impl'
require_relative 'num-impl'
require_relative 'no-arg-impl'
require_relative 'rational-help'

class DoubleUError < RuntimeError
end

# Heavy lifter to parse and execute lines of Double-U code
class Main
  def initialize(src, s_option)
    @src = src
    @s_option = s_option
    @list = ListImpl.new
    @num = NumImpl.new
    @noarg = NoArgImpl.new
    @rh = RationalHelp.new
    @vars = {} # Hash table of variables
    @linenum = 1 # variable; used for error messages
  end

  def error(string)
    raise DoubleUError, "Double-u runtime error: #{string}. (line #{@linenum})"
  end

  def convert_strings(inst)
    inst.gsub!(/(['"]).*?\1/) { |s| s[1..-2].unpack('C*').to_s }
    inst.delete!(',')
  end

  def num_regex
    %r{-?\d+((\.|/)\d+)?}
  end

  def array_regex
    /\[ *((?:#{num_regex} +)*#{num_regex}?)\]/
  end

  def to_num(s)
    error 'division by zero' if s =~ %r{/0$}
    s.include?('.') ? s.to_f : @rh.r2n(s.to_r)
  end

  def to_list(s)
    s[1..-2].split.map { |x| to_num(x) }
  end

  def set_var(name, val)
    error 'trying to assign void to a variable' if val.nil?
    @vars[name.to_sym] = val
  end

  def get_var(name)
    lookup = name.to_sym
    error "Variable #{name} undeclared" unless @vars.key?(lookup)
    @vars[lookup]
  end

  def find_type(var, func)
    case var
    when Array then @list
    when Numeric then @num
    else error "Invalid argument to function #{func}"
    end
  end

  def call_function(name, input)
    return @noarg.send("Impl_#{name}") if input.nil?
    find_type(input, name).send("Impl_#{name}", input)
  end

  def merge(k1, k2)
    v1 = get_var(k1)
    v2 = get_var(k2)
    if find_type(v1, 'merge') != find_type(v2, 'merge')
      error "Type inputs to merge don't match"
    end
    v1 + v2
  end

  def parse_expr(exp)
    case exp
    when /^#{array_regex}$/ then to_list(exp)
    when /^#{num_regex}$/ then to_num(exp)
    else execline(exp)
    end
  end

  def safe_print(val)
    error 'trying to print void' if val.nil?
    print val, "\n"
  end

  def parse_line(inst)
    # Inline comment or brackets around code
    if /^(?<code>.*?);.*$|^\((?<code>.*)\)$/ =~ inst
      execline(code.strip)
    # Variable assignment
    elsif /^let +(?<var>\w+) *= *(?<exp>.*)$/ =~ inst
      set_var(var, parse_expr(exp))
    # Printing the result of an expression
    elsif /^print +(?<code>.*)$/ =~ inst
      safe_print(execline(code))
    # Adding two numbers or array variables
    elsif /^merge +(?<v1>\w+) (?<v2>\w+)$/ =~ inst
      merge(v1, v2)
    # Function call
    elsif /^(?<cmd>[a-z]+)! *(?<exp>.*)$/ =~ inst
      call_function(cmd, parse_expr(exp))
    # Just a literal var. Allows "let x = y"
    elsif /^(?<v>\w+)$/ =~ inst
      get_var(v)
    else
      error 'Invalid instruction'
    end
  end

  def execline(inst)
    # skip blank spaces and comments
    return if inst =~ /^\s*(;|$)/
    # The 'S' option converts all strings to arrays of ints (like char*'s in C)
    convert_strings(inst) if @s_option
    parse_line(inst.strip.downcase)
  rescue NoMethodError => e
    raise e unless e.message.include?('Impl')
    base_message = e.message.split("\n").first
    error base_message.gsub(/#<(\w+).*>/, 'type \1').gsub(/Impl_?/, '')
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
