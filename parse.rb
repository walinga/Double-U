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

    # remove all whitespace
    @@src = @@src.gsub(/\s+|\n/, "")

    literals = @@src.split('U')
    insts = Set.new

    literals.each do |i|
      # Number
      if /^\d+$/.match(i)
        insts.add(i.to_i)
      # Array
      elsif /^\[((-?\d+,)*-?\d+)?\]$/.match(i)
        insts.merge(i[1..-2].split(','))
      #Array instruction
      elsif /\w+\[((-?\d+,)*-?\d+)?\]$/.match(i)
        res =  eval '@@list.Impl_' + i.gsub('[','([').gsub(']','])')
        insts.merge(res)
      else
        raise "Double-u syntax error: Trying to union a non-array or int"
      end
    end

    ##print literals
    insts.each do |i|
      puts i
    end
  end
end
