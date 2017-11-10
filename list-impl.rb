#
## Useful List Implementations
#

class ListImpl

  def Impl_shuffle(x)
    x.shuffle
  end
  
  def Impl_select(x)
    x.empty? ? 0 : x.sample
  end

  def Impl_mean(x)
    return 0 if x.empty?
    sum = 0
    x.each do |i|
      sum += i
    end
    sum/x.length
  end

  # Helper function: Finds median of list with length < 6
  def small_median(x)
    y = x.sort
    k = x.length
    return y[k/2] if k.odd?
    # If x has an even # of elements, average middle two
    (y[k/2-1] + y[k/2])/2.0
  end

  # Recursive helper function for median
  def median_rec(x)
    return 0 if x.empty?
    if x.length < 6
      return small_median(x)
    end
    median_rec x.each_slice(5).to_a.map { |i| small_median(i) }
  end

  def Impl_median(x)
    median_rec(x).round
  end

  # Retuns 0 for an empty list
  def Impl_mode(x)
    return 0 if x.empty?
    freq = {}
    x.each do |i|
      freq[i] = (freq.has_key? i) ? freq[i] + 1 : 0
    end
    max = freq.max_by{ |k,v| v }[1]
    x.select { |j| freq[j] == max }.sample
  end
  
  def Impl_remove(x)
    return x if x.empty?
    y = Array.new(x)
    y.delete_at(rand(x.length))
    y
  end

  def Impl_subset(x)
    x.combination(Random.new.rand(0..x.length)).to_a
  end

  ## This section is for functions built using those above
  #

  def Impl_average(x)
    Impl_select([Impl_mean(x), Impl_median(x), Impl_mode(x)])
  end

  def Impl_gemiddelde(x)
    Impl_mean(Array.new(Impl_select(x)) {Impl_average(x)})
  end
  
  ## Future Ideas
  # random subset of a list
  # something based on current time?

end

