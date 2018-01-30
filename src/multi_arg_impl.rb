
#
## Functions which take multiple arguments
## Every function should accept both [[],[]] or [1,2,3]
#
class MultiArgImpl
  def impl_merge(vals)
    vals.reduce(:+)
  end

  def impl_difference(vals)
    vals.reduce(:-)
  end
end
