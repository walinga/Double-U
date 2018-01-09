#
## Functions which take integers as input
#

require_relative 'list-impl'

class NumImpl 

  def Impl_twist(i)
    i < 1000 ? rand(i..1000) : rand(0..i)
  end

  def Impl_wrap(i)
    Array.new(i.abs) { rand(1000) }
  end

  def Impl_chain(i)
    # Chain together a random sequence of i commands
    input = Impl_wrap(i)
    lst = ListImpl.new
    print 'wrap'

    (1..i.abs).to_a.each do |j|
      obj = input.is_a?(Array) ? lst : self
      meth = obj.methods.grep(/Impl/).reject{|x| x =~ /chain/}.sample
      raw = meth.to_s.gsub('Impl_','')
      print " -> #{raw}"
      input = obj.send(meth, input)
    end

    print "\n"
    input
  end

  def Impl_coerce(i)
    i.is_a?(Rational) ? i.to_f : i.round
  end
end  
