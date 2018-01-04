#
## Useful List Implementations
#

class ListImpl

  # helper to give exact rational numbers
  def r_div(a,b)
    r = a / b.to_r
    r.denominator == 1 ? r.to_i : r
  end

  def Impl_shuffle(x)
    x.shuffle!
  end
  
  def Impl_select(x)
    x.empty? ? 0 : x.sample
  end

  def Impl_mean(x)
    return 0 if x.empty?
    # Mean for arrays is an array of the element-by-element means of x
    if x.first.is_a?(Array)
      f, *rest = x # Can't use transpose because the sub-arrays might be diff. lengths
      f.zip(*rest).map(&:compact).map { |x| r_div(x.reduce(:+), x.length) }
    else
      r_div(x.reduce(:+), x.length)
    end
  end

  #
  # # Median uses the following 3 helper functions to run in O(n) time
  #

  def small_median(x)
    x.sort!
    k = x.length
    return x[k/2] if k.odd?
    # If x has an even # of elements, average middle two
    x.first.is_a?(Array) ? 
      x[k/2-1].zip(x[k/2]).map(&:compact).map { |x| x.reduce(:+) / k.to_r }
      : (x[k/2-1] + x[k/2])/2.to_r
  end

  # Helper function to find the median of medians of x
  def find_m(x)
    while x.length > 5
      x = x.each_slice(5).to_a.map { |i| small_median(i) }
    end
    small_median(x)
  end

  def kth_smallest(x,k)
    while x.length > 5
      m = find_m(x)
      e,l,r = [],[],[]
      x.each { |i| [e,l,r][m <=> i] << i }
      if k < l.length
        x = l
      elsif k < l.length + e.length
        return m
      else # k >= l.length + e.length
        x = r
        k -= l.length + e.length
      end
    end
    x.sort![k]
  end

  def Impl_median(x)
    return 0 if x.empty?
    t1 = Time.now
    k = kth_smallest(x, x.length/2)
    k = r_div(k,1)
    puts "Median is #{k} in #{(Time.now - t1)*1000} ms"
    return k
  end

  def Impl_sortedmedian(x)
    return 0 if x.empty?
    t1 = Time.now
    x.sort!
    l = x.length
    k = l.odd? ? x[l/2] : r_div(x[l/2-1]+x[l/2], 2)
    puts "Median is #{k} in #{(Time.now - t1)*1000} ms"
    return k
  end

  # Retuns 0 for an empty list
  def Impl_mode(x)
    return 0 if x.empty?
    freq = {}
    x.each { |i| freq[i] = (freq[i] || 0) + 1 }
    max = freq.max_by { |k,v| v }[1]
    freq.select { |k,v| v == max }.map(&:first).sample
  end
  
  def Impl_remove(x)
    return x if x.empty?
    x.delete_at(rand(x.length))
    return x
  end

  def Impl_subset(x)
    x.combination(Random.new.rand(0..x.length)).to_a
  end

  def Impl_variance(x)
    # more intuitive to use Impl_mean, but this avoids floating point errors
    n = x.length
    numerator = n * x.map{|n| n*n}.reduce(:+) - x.reduce(:+)**2
    r_div(numerator, n**2)
  end

  ## This section is for functions built using those above
  #

  def Impl_average(x)
    Impl_select([Impl_mean(x), Impl_median(x), Impl_mode(x)])
  end

  def Impl_gmdl(x)
    Impl_mean(Array.new(Impl_select(x)) {Impl_average(x)})
  end

end

