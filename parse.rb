require 'set'
require_relative 'list-impl'

class Main
  @@src
  @@list
  @@vars

  def initialize(src)
    @@src = src
    @@list = ListImpl.new
    @@vars = {} # Hash table of variables
  end

  def checkDef(var) 
    unless @@vars.has_key?(var)
      raise "Double-u syntax error: Variable #{var} undeclared"
    end
  end

  def checkFunc(func)
    unless eval "defined? @@list.Impl_#{func}"
      raise "Double-u syntax error: Function #{func} not defined"
    end
  end

  # Currently only checks if type is Array
  def checkType(var, func)
    unless var.kind_of?(Array)
      raise "Double-u syntax error: Invalid argument to function #{func}"
    end
  end

  # TODO: Allow arbitrary parentheses (may require 'real' parsing)
  #       Print line number in error messagess
  #       Create a formal specification of the language
  #       Test, test, test
  # DONE: Error checking - undefined functions and variables
  #       Allow expressions as rvalues
  #       Add support for integer variable
  #       Allow expressions as rvalues for list functionss
  def execline(inst)
    case inst
      when /^$/  # Blank space
      when /^;.*$/ # Comment
      when /^let +(\w+) *= *\[ *((\d *)*)\]$/
        @@vars[$1] = $2.split.map { |x| x.to_i }
      # Expression as rvalue for 'let'
      when /^let +(\w+) *= *(.*)$/
        val = execline($2)
        raise "Double-u syntax error: trying to assign void to a variable" if val.nil?
        @@vars[$1] = val
      when /^print +(\w+)$/
        checkDef($1)
        print @@vars[$1], "\n"
      when /^print +(.*)$/
        val = execline($1)
        raise "Double-u syntax error: trying to print void" if val.nil?
        print val, "\n"
      # List function with variable as param
      when /^([a-z]+) +(\w+)$/
        checkFunc($1)
        checkDef($2)
        input = @@vars[$2]
        checkType(input, $1)
        return eval "@@list.Impl_#{$1}(#{input})"
      # List function with literal as param
      when /^([a-z]+) *\[ *((\d *)*)\]$/
        checkFunc($1)
        return eval "@@list.Impl_#{$1}(#{$2.split.map { |x| x.to_i}})"
      # List function with result of another function as param
      when /^([a-z]+) +(.*)$/
        val = execline($2)
        checkType(val, $1)
        return eval "@@list.Impl_#{$1}(#{val})"
      else
        puts "oops" # debug
        raise "Double-u syntax error: Invalid instruction"
    end
    # The default return value is nil
    return nil
  end

  def run
    if @@src[0] == '`'
      print @@src[1..-1]
      exit
    end

    # Since Double-U is a command-based language, we parse
    #  each line separately
    literals = @@src.split("\n").map { |x| x.strip }

    literals.each do |inst|
      execline inst
    end

  end
end
