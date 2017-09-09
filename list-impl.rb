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

# Helper function: Finds median of list with length < 6
def small_median(x)
  y = x.sort
  k = x.length
  return y[k/2] if k.odd?
  # If x has an even # of elements, average middle two
  return (y[k/2-1] + y[k/2])/2.0
end

# Recursive helper function for median
def median_rec(x)
  return 0 if x.empty?
  if x.length < 6
    return small_median(x)
  end
  return median_rec x.each_slice(5).to_a.map { |i| small_median(i) }
end

def Impl_median(x)
  return median_rec(x).round
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

