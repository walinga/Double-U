#
## Useful List Implementations
#
from random import shuffle,choice,randint

def Impl_shuffle(x):
  y=x[:]
  shuffle(y)
  return y
  
def Impl_select(x):
  if len(x)==0: return 0
  return choice(x)
  
def Impl_average(x):
  sum = 0
  for i in x:
    sum += i
  return sum/len(x)
  
def Impl_remove(x):
  if len(x)==0: return x
  y=x[:]
  y.pop(randint(0,len(x)-1))
  return y
  
## Future Ideas
# random subset of a list
# something based on current time?

#Tests
p = [1,2,3,4,5,6,7,8]
print Impl_shuffle(p)
print p
print Impl_select([1,2,3,4,5])
print Impl_average([30,32,34,36])
print Impl_remove([1,4,5,6,7,8,])
  
