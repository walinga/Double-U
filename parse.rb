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

  # TODO: Add type-checking (if necessary)
  #       Allow expressions as rvalues for list functions
  #       Create a formal specification of the language
  # DONE: Error checking - undefined functions and variables
  #       Allow expressions as rvalues
  #       Add support for integer variables
  def execline(inst)
    case inst
      when /^ *$/  # Blank space
      when /^;.*$/ # Comment
      when /^let +(\w+) *= *\[ *((\d *)*)\] *$/
        @@vars["#{$1}"] = "#{$2}".split.map { |x| x.to_i }
      # Expression as rvalue for 'let'
      when /^let +(\w+) *= *(.*)$/
        val = execline("#{$2}")
        raise "Double-u syntax error: trying to assign void to a variable" if val.nil?
        @@vars["#{$1}"] = val
      when /^print +(\w+) *$/
        # Assumes array for now
        checkDef("#{$1}")
        print @@vars["#{$1}"], "\n"
      when /^print +(.*)$/
        val = execline("#{$1}")
        raise "Double-u syntax error: trying to print void" if val.nil?
        print val, "\n"
      when /^([a-z]+) +(\w+) *$/
        checkFunc("#{$1}")
        checkDef("#{$2}")
        input = @@vars["#{$2}"]
        unless input.kind_of?(Array)
          raise "Double-u syntax error: Invalid argument to function #{$1}"
        end
        return eval "@@list.Impl_#{$1}(#{input})"
      when /([a-z]+) *\[ *((\d *)*)\] */ 
        checkFunc("#{$1}")
        return eval "@@list.Impl_#{$1}(#{$2.split.map { |x| x.to_i}})"
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
    literals = @@src.split("\n")

    literals.each do |inst|
      execline inst
    end

  end
end
