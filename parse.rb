require 'set'
require_relative 'list-impl'

class Main
  @@src
  @@list

  def initialize(src)
    @@src = src
    @@list = ListImpl.new
  end

  def run
    if @@src[0] == '`'
      print @@src[1..-1]
      exit
    end

    # Since Double-U is a command-based language, we parse
    #  each line separately
    literals = @@src.split("\n")

    vars = {} # Hash table of variables

    # TODO: Add type-checking
    #       Add support for integer vars
    #       Allow expressions as rvalues (maybe do actual parsing)
    literals.each do |inst|
      case inst
        when /^let +(\w+) *= *\[ *((\d *)*)\] *$/
          vars["#{$1}"] = "#{$2}".split.map { |x| x.to_i }
          puts "let please" # debug
        when /^print +(\w+).*/
          # Assumes array for now
          print vars["#{$1}"], "\n"
          puts "You printed: #{$1}" #debug
        when /([a-z]+) +(\w+)/
          res = eval '@@list.Impl_' + "#{$1}(" + vars["#{$2}"].to_s + ")"
          puts "other command: #{res}"
        else
          puts "oops" # debug
          raise "Double-u syntax error: Invalid instruction"
      end
    end

  end
end
