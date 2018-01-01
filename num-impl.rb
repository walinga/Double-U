#
## Functions which take integers as input
#

class NumImpl 

  def Impl_twist(i)
    @seed = (Random.new(i).rand * 1000).round
  end

  def Impl_wrap(i)
    seed = @seed || Random.new_seed
    prng = Random.new(seed)
    Array.new(i) { prng.rand(1000) }.map(&:round)
  end
end  
