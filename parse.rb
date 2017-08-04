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

  # TODO: Add type-checking
  #       Add support for integer vars
  #       Allow expressions as rvalues (maybe do actual parsing)
  #       Create a formal specification of the language
  # DONE: Error checking - undefined functions and variables
  def execline(inst)
    case inst
      when /^let +(\w+) *= *\[ *((\d *)*)\] *$/
        @@vars["#{$1}"] = "#{$2}".split.map { |x| x.to_i }
        puts "let please" # debug
      when /^print +(\w+).*/
        # Assumes array for now
        unless @@vars.has_key?("#{$1}")
          raise "Double-u syntax error: Variable #{$1} undeclared"
        end
        print @@vars["#{$1}"], "\n"
        puts "You printed: #{$1}" #debug
      when /([a-z]+) +(\w+)/
        unless eval 'defined? @@list.Impl_' + "#{$1}"
          raise "Double-u syntax error: Function #{$1} not defined" 
        end
        unless @@vars.has_key?("#{$2}")
          raise "Double-u syntax error: Variable #{$2} undeclared"
        end
        res = eval '@@list.Impl_' + "#{$1}(" + @@vars["#{$2}"].to_s + ")"
        puts "other command: #{res}"
      else
        puts "oops" # debug
        raise "Double-u syntax error: Invalid instruction"
    end
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
