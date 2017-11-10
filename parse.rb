require 'set'
require_relative 'list-impl'
require_relative 'num-impl'

class Main
  @src
  @list
  @num
  @vars
  @linenum

  def initialize(src)
    @src = src
    @list = ListImpl.new
    @num = NumImpl.new
    @vars = {} # Hash table of variables
    @linenum = 1 # variable; used for error messages
  end

  def error(string)
    raise "Double-u syntax error: #{string}. (line #{@linenum})"
  end

  def checkDef(var) 
    unless @vars.has_key?(var)
      error "Variable #{var} undeclared"
    end
  end

  def checkFunc(func)
    unless eval "defined? @list.Impl_#{func} || defined? @num.Impl_#{func}"
      error "Function #{func} not defined"
    end
  end

  # Currently only checks if type is Array
  def checkType(var, func)
    if var.kind_of?(Array)
      'list'
    elsif var.kind_of?(Integer)
      'num'
    else
      error "Invalid argument to function #{func}"
    end
  end

  def execline(inst)
    case inst
      when /^$/  # Blank space
      when /^;.*$/ # Comment
      when /^(.*);.*$/
        return execline($1.strip)
      when /^\((.*)\)$/
        return execline($1.strip)
      when /^let +(\w+) *= *\[ *((\d *)*)\]$/
        @vars[$1] = $2.split.map { |x| x.to_i }
      # Expression as rvalue for 'let'
      when /^let +(\w+) *= *(.*)$/
        val = execline($2)
        error "trying to assign void to a variable" if val.nil?
        @vars[$1] = val
      # Note: printing literals is prohibited
      when /^print +(\w+)$/
        checkDef($1)
        print @vars[$1], "\n"
      when /^print +(.*)$/
        val = execline($1)
        error "trying to print void" if val.nil?
        print val, "\n"
      when /^merge +(\w+) (\w+)$/
        checkDef($1)
        checkDef($2)
        a1, a2 = @vars[$1], @vars[$2]
        if checkType(a1, "merge") != checkType(a2,"merge")
          error "Type inputs to merge don't match"
        end
        return a1 + a2
      # Num function with literal as param
      when /^([a-z]+)! *(\d+)$/
        checkFunc($1)
        return eval "@num.Impl_#{$1}(#{$2})"
      # Any function with variable as param
      when /^([a-z]+)! +(\w+)$/
        checkFunc($1)
        checkDef($2)
        input = @vars[$2]
        type = checkType(input, $1)
        return eval "@#{type}.Impl_#{$1}(#{input})"
      # List function with literal as param
      when /^([a-z]+)! *\[ *((\d *)*)\]$/
        checkFunc($1)
        return eval "@list.Impl_#{$1}(#{$2.split.map { |x| x.to_i}})"
      # Any function with result of another function as param
      when /^([a-z]+)! +(.*)$/
        val = execline($2)
        type = checkType(val, $1)
        return eval "@#{type}.Impl_#{$1}(#{val})"
      else
        error "Invalid instruction"
    end
    # The default return value is nil
    nil
  rescue NoMethodError => e
    error e.message.split("\n").first.gsub("`Impl_","'")
  end

  def run
    if @src[0] == '`'
      print @src[1..-1]
      exit
    end

    # Since Double-U is a command-based language, we parse
    #  each line separately
    literals = @src.split("\n").map { |x| x.strip }

    literals.each do |inst|
      execline inst
      @linenum += 1
    end

  end
end
