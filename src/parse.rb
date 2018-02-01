require_relative 'list_impl'
require_relative 'num_impl'
require_relative 'no_arg_impl'
require_relative 'multi_arg_impl'
require_relative 'parse_help'

class DoubleUError < RuntimeError
end

# Heavy lifter to parse and execute lines of Double-U code
class Main
  def initialize(src, options)
    @src = src
    @ph = ParseHelp.new(options)
    @list = ListImpl.new
    @num = NumImpl.new(options)
    @noarg = NoArgImpl.new(@ph)
    @multi_arg = MultiArgImpl.new
    @vars = {} # Hash table of variables
    @linenum = 1 # variable; used for error messages
  end

  def set_var(name, val)
    @ph.error 'trying to assign void to a variable' if val.nil?
    @vars[name.to_sym] = val
  end

  def get_var(name)
    lookup = name.to_sym
    @ph.error "Variable #{name} undeclared" unless @vars.key?(lookup)
    @vars[lookup]
  end

  def find_type(var, func)
    case var
    when Array then @list
    when Numeric then @num
    else @ph.error "Invalid argument to function #{func}"
    end
  end

  def call_function(name, input)
    return @noarg.send("impl_#{name}") if input.nil?
    find_type(input, name).send("impl_#{name}", input)
  end

  def split_args(name, inputs)
    vals = inputs.split.map { |v| get_var(v) }
    all_match = vals.map { |v| find_type(v, name) }.uniq.length == 1
    all_match ? vals : (@ph.error "Type inputs to #{name} don't match")
  end

  def parse_expr(exp)
    case exp
    when /^#{@ph.array_regex}$/ then @ph.to_list(exp)
    when /^#{@ph.num_regex}$/ then @ph.to_num(exp)
    when /^$/ then nil
    else parse_line(exp)
    end
  end

  # Basic idea is that user defined functions get added to the Main class
  # Returns a string specifying the function name
  def define_func(cmd, defn)
    objs = [@list, @num, @multi_arg, @noarg]
    @ph.check_if_definable(objs, cmd, defn)
    define_singleton_method("impl_#{cmd}") { |p| execline("#{defn} #{p}") }
    @ph.add_user_def(cmd)
    cmd + '!'
  end

  def function_triage(cmd, exp)
    impl_cmd = "impl_#{cmd}"
    if methods.include? impl_cmd.to_sym
      send(impl_cmd, exp)
    elsif /^((?:\w+ +)+\w+)$/ =~ exp
      @multi_arg.send(impl_cmd, split_args(cmd, exp))
    else
      call_function(cmd, parse_expr(exp))
    end
  end

  def parse_keyword(inst)
    # Variable assignment
    if /^let +(?<var>\w+) *= *(?<exp>.*)$/ =~ inst
      set_var(var, parse_expr(exp))
    # Printing the result of an expression
    elsif /^print +(?<code>.*)$/ =~ inst
      @ph.safe_print(parse_line(code))
    elsif /^define (?<cmd>[a-z]+)! *=(?<defn>(?: *[a-z]+!)+)$/ =~ inst
      define_func(cmd, defn)
    else
      @ph.error 'Invalid instruction'
    end
  end

  def parse_line(inst)
    # Inline comment or brackets around code
    if /^(?<code>.*?);.*$|^\((?<code>.*)\)$/ =~ inst
      parse_line(code.strip)
    # Function call
    elsif /^(?<cmd>[a-z]+)! *(?<exp>.*)$/ =~ inst
      function_triage(cmd, exp)
    # Just a literal var. Allows "let x = y"
    elsif /^(?<v>\w+)$/ =~ inst
      get_var(v)
    else
      parse_keyword(inst)
    end
  end

  def execline(inst)
    # skip blank spaces and comments
    return if inst =~ /^\s*(;|$)/
    @ph.stringify(parse_line(@ph.numify(inst).strip.downcase))
  rescue NoMethodError => e
    @ph.handle_no_method(e)
  end

  def run
    # Since Double-U is a command-based language, we parse each line separately
    @src.split("\n").each do |inst|
      execline inst
      @linenum += 1
    end
  end
end
