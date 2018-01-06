#
## Functions which take integers as input
#

require_relative 'list-impl'

class NumImpl 

  def Impl_twist(i)
    seed = (Random.new(i).rand * 1000)
    @prng = Random.new(seed)
    seed
  end

  def Impl_wrap(i)
    prng = @prng || Random.new
    Array.new(i) { prng.rand(1000) }
  end

  def Impl_chain(i)
    # Chain together a random sequence of i commands
    input = Impl_wrap(i)
    lst = ListImpl.new
    print 'wrap'

    (1..i).to_a.each do |j|
      obj = input.is_a?(Array) ? lst : self
      meth = obj.methods.grep(/Impl/).reject{|x| x =~ /chain/}.sample
      raw = meth.to_s.gsub('Impl_','')
      print " -> #{raw}"
      input = obj.send(meth, input)
    end

    print "\n"
    input
  end
end  
