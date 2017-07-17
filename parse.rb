require 'set'
class Main
  @@src

  def initialize(src)
    @@src = src
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
      if /^\d+$/.match(i)
        insts.add(i.to_i)
      elsif /^\[((-?\d+,)*-?\d+)?\]$/.match(i)
        insts.merge(i[1..-2].split(','))
      elsif /\w+\[((-?\d+,)*-?\d+)?\]$/.match(i)
        p=i.split('[')
        func_res = `echo #{p[0]} #{'['+p[1]} | python list-impl.py`
        insts.merge(func_res[1..-3].gsub(/\s+|\n/, "").split(','))
      else
        raise "Syntax error: Trying to union a non-array or int"
      end
    end

    ##print literals
    insts.each do |i|
      puts i
    end
  end
end
