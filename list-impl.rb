#
## Useful List Implementations
#

class ListImpl

  ## helpers to give exact rational numbers
  #

  def r2n(r)
    r.denominator == 1 ? r.to_i : r
  end

  # Make sure b is not a float when calling this
  def r_div(a,b)
    r2n(a / b.to_r)
  end

  ###

  def Impl_shuffle(x)
    x.shuffle!
  end
  
  def Impl_select(x)
    x.empty? ? 0 : x.sample
  end

  def Impl_mean(x)
    return 0 if x.empty?
    r_div(x.reduce(:+), x.length)
  end

  def Impl_median(x)
    return 0 if x.empty?
    x.sort!
    l = x.length
    l.odd? ? x[l/2] : r_div(x[l/2-1]+x[l/2], 2)
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
    x.sample(Random.new.rand(0..x.length))
  end

  def Impl_variance(x)
    return 0 if x.empty?
    # more intuitive to use Impl_mean, but this avoids floating point errors
    n = x.length
    numerator = n * x.map{|n| n*n}.reduce(:+) - x.reduce(:+)**2
    r_div(numerator, n**2)
  end

  def Impl_range(x)
    return 0 if x.empty?
    x.max - x.min
  end

  # Helper for IQR, assumes x is sorted
  def pth_quantile(x,p)
    m = (x.length+1)*p
    return 0 if m < 1 || m > x.length
    if m.ceil == m
      x[m-1]
    else
      j = m.floor
      r_div(x[j-1]+x[j], 2)
    end
  end

  def Impl_iqr(x)
    x.sort!
    upper, lower = pth_quantile(x, 0.75), pth_quantile(x, 0.25)
    r2n(upper - lower)
  end

  def Impl_quantile(x)
    x.sort!
    pth_quantile(x, Random.new.rand.round(2))
  end

  ## This section is for functions built using those above
  #

  def Impl_std(x)
    Math.sqrt(Impl_variance(x))
  end

  def Impl_average(x)
    Impl_select([Impl_mean(x), Impl_median(x), Impl_mode(x)])
  end

  def Impl_gmdl(x)
    Impl_mean(Array.new(Impl_select(x)) {Impl_average(x)})
  end

  def Impl_trim(x)
    trim = Impl_std(x).to_i
    trim.times { x = Impl_remove(x) }
    Impl_shuffle(x)
  end

  def Impl_normalize(x)
    mu = Impl_mean(x)
    std_dev = Impl_std(x)
    x.map { |n| (n-mu)/std_dev }
  end

end

