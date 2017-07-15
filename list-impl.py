#
## Useful List Implementations
#
from random import shuffle,choice

def Impl_shuffle(x):
  shuffle(x)
  return x
  
def Impl_select(x):
  if len(x)==0: return 0
  return choice(x)
  
def Impl_average(x):
  sum = 0
  for i in x:
    sum += i
  return sum
  
