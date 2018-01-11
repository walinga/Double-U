require_relative 'rational-help'

#
## Useful List Implementations
#

class ListImpl

  def initialize
    @rh = RationalHelp.new
  end

  def Impl_shuffle(x)
    x.dup.shuffle!
  end
  
  def Impl_select(x)
    x.empty? ? 0 : x.sample
  end

  def Impl_mean(x)
    return 0 if x.empty?
    @rh.r_div(x.reduce(:+), x.length)
  end

  def Impl_median(x)
    return 0 if x.empty?
    y = x.sort
    l = y.length
    l.odd? ? y[l/2] : @rh.r_div(y[l/2-1]+y[l/2], 2)
  end

  def Impl_mode(x)
    return 0 if x.empty?
    freq = {}
    x.each { |i| freq[i] = (freq[i] || 0) + 1 }
    max = freq.max_by { |k,v| v }[1]
    freq.select { |k,v| v == max }.map(&:first).sample
  end
  
  def Impl_remove(x)
    y = x.dup
    y.delete_at(rand(x.length))
    return y
  end

  def Impl_subset(x)
    x.sample(rand(0..x.length))
  end

  def Impl_size(x)
    x.length
  end

  def Impl_variance(x)
    return 0 if x.empty?
    # more intuitive to use Impl_mean, but this avoids floating point errors
    n = x.length
    numerator = n * x.map{|n| n*n}.reduce(:+) - x.reduce(:+)**2
    @rh.r_div(numerator, n**2)
  end

  def Impl_range(x)
    return 0 if x.empty?
    x.max - x.min
  end

  # Helper for IQR, assumes x is sorted
  def pth_quantile(x,p)
    m = (x.length+1)*p
    return 0 if m < 1 || m > x.length
    j = m.floor
    j == m ? x[m-1] : @rh.r_div(x[j-1]+x[j], 2)
  end

  def Impl_iqr(x)
    y = x.sort
    upper, lower = pth_quantile(y, 0.75), pth_quantile(y, 0.25)
    @rh.r2n(upper - lower)
  end

  def Impl_quantile(x)
    y = x.sort
    pth_quantile(y, rand.round(2))
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

  def shape_desc(x, desc)
    mu = Impl_mean(x)
    top = x.map { |n| (n-mu)**desc }.reduce(:+)
    numerator = @rh.r_div(top, x.length)
    v = Impl_variance(x)
    numerator / v**(desc/2r)
  end

  def Impl_skewness(x)
    shape_desc(x, 3)
  end

  def Impl_kurtosis(x)
    shape_desc(x, 4)
  end

end

