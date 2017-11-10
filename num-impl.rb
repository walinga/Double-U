#
## Functions which take integers as input
#

require_relative 'list-impl'

class NumImpl 

  def Impl_twist(i)
    Random.new(i)
  end

  def Impl_lock(i)
    raw_arr = [i] * i
    arr = ListImpl.new.Impl_subset(raw_arr)
    sleep arr.length
  end
end  
