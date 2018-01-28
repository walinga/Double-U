
#
## Functions which take multiple arguments
## Every function should accept both [[],[]] or [1,2,3]
#
class MultiArgImpl
  def Impl_merge(vals)
    vals.reduce(:+)
  end

  def Impl_difference(vals)
    vals.reduce(:-)
  end
end
