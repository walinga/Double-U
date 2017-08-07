#
## Useful List Implementations
#

class ListImpl

def Impl_shuffle(x)
  return x.shuffle
end
  
def Impl_select(x)
  return 0 if x.empty?
  return x.sample
end

def Impl_average(x)
  return 0 if x.empty?
  sum = 0
  x.each do |i|
    sum += i
  end
  return sum/x.length
end
  
def Impl_remove(x)
  return x if x.empty?
  y = Array.new(x)
  y.delete_at(rand(x.length))
  return y
end
  
## Future Ideas
# random subset of a list
# something based on current time?

end

