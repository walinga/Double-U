#
## Functions which take integers as input
#

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
end  
