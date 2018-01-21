require_relative 'list-impl'
require_relative 'num-impl'
require_relative 'no-arg-impl'
require_relative 'rational-help'

class DoubleUError < RuntimeError
end

# Heavy lifter to parse and execute lines of Double-U code
class Main
  def initialize(src, options)
    @src = src
    @options = options
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

  def numify(inst)
    return inst unless @options[:string]
    # The 'S' option converts all strings to arrays of ints (like char*'s in C)
    inst.gsub(/(['"]).*?\1/) { |s| s[1..-2].unpack('C*').to_s }.delete(',')
  end

  def stringify(a)
    # The 'P' option formats output arrays as strings
    @options[:print] && a.is_a?(Array) ? a.pack('C*') : a
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

  def merge(names)
    vals = names.split.map { |v| get_var(v) }
    all_match = vals.map { |v| find_type(v, 'merge') }.uniq.length == 1
    error "Type inputs to merge don't match" unless all_match
    vals.reduce(:+)
  end

  def parse_expr(exp)
    case exp
    when /^#{array_regex}$/ then to_list(exp)
    when /^#{num_regex}$/ then to_num(exp)
    when /^$/ then nil
    else parse_line(exp)
    end
  end

  def safe_print(val)
    error 'trying to print void' if val.nil?
    print val, "\n"
  end

  def parse_line(inst)
    # Inline comment or brackets around code
    if /^(?<code>.*?);.*$|^\((?<code>.*)\)$/ =~ inst
      parse_line(code.strip)
    # Variable assignment
    elsif /^let +(?<var>\w+) *= *(?<exp>.*)$/ =~ inst
      set_var(var, parse_expr(exp))
    # Printing the result of an expression
    elsif /^print +(?<code>.*)$/ =~ inst
      safe_print(parse_line(code))
    # Adding any number of ints or lists
    elsif /^merge!(?<vs>(?: *\w+)+)$/ =~ inst
      merge(vs)
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
    stringify(parse_line(numify(inst).strip.downcase))
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
