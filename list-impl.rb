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

def Impl_mean(x)
  return 0 if x.empty?
  sum = 0
  x.each do |i|
    sum += i
  end
  return sum/x.length
end

# Consider defining median as aveage of middle two
def Impl_median(x)
  return 0 if x.empty?
  if x.length < 6
    y = x.sort
    return y[x.length/2]
  end
  # Under construction
end

# Retuns 0 for an empty list
def Impl_mode(x)
  freq = {}
  x.each do |i|
    freq[i] = (freq.has_key? i) ? freq[i] + 1 : 0
  end
  max, mode = 0, 0
  x.each do |j|
    if freq[j] > max
      max = freq[j]
      mode = j
    # Consider: create a list of max value, then pick
    elsif freq[j] == max
      mode = [j,mode].sample
    end
  end
  return mode
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

