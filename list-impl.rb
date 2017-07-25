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
  sum = 0
  x.each do |i|
    sum += i
  end
  return sum/x.length
end
  
def Impl_remove(x)
  return x if x.empty?
  y = Array.new(x)
  y.delete_at(rand(x.length-1))
  return y
end
  
## Future Ideas
# random subset of a list
# something based on current time?

#
## Tests

#  p = [1,2,3,4,5,6,7,8]
 # print Impl_shuffle(p), "\n"
#  print p, "\n"
 # print Impl_select([1,2,3,4,5]), "\n"
#  print Impl_average([30,32,34,35]), "\n"
 # q = [1,4,5,6,7,8]
#  print Impl_remove(q), "\n"
 # print q, "\n"
end
  
