#
## Functions which take integers as input
#

require_relative 'list-impl'

class NumImpl 

  # Both of these are pretty useless
  # Future idea: Make array out of num

  def Impl_twist(i)
    (Random.new(i).rand * 1000).round
  end

  def Impl_lock(i)
    raw_arr = [i] * i
    arr = ListImpl.new.Impl_subset(raw_arr)
    sleep arr.length
  end
end  
