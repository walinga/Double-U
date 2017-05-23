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
      elsif i[0]=='[' && i[-1]==']'
        insts.merge(i[1..-2].split(','))
      else
        insts.add(i)
      end
    end

    ##print literals
    insts.each do |i|
      puts i
    end
  end
end
