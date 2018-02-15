require_relative 'rational_help'

#
## Useful List Implementations
#
class ListImpl
  def initialize(rational_help)
    @rh = rational_help
  end

  def impl_shuffle(x)
    x.dup.shuffle!
  end

  def impl_select(x)
    x.empty? ? 0 : x.sample
  end

  def impl_mean(x)
    return 0 if x.empty?
    @rh.r_div(x.reduce(:+), x.length)
  end

  def impl_median(x)
    return 0 if x.empty?
    y = x.sort
    l = y.length / 2
    y.length.odd? ? y[l] : impl_mean(y[l - 1, 2])
  end

  def impl_mode(x)
    return 0 if x.empty?
    freq = {}
    x.each { |i| freq[i] = (freq[i] || 0) + 1 }
    max = freq.max_by { |_k, v| v }[1]
    freq.select { |_k, v| v == max }.map(&:first).sample
  end

  def impl_remove(x)
    y = x.dup
    y.delete_at(rand(x.length))
    y
  end

  def impl_subset(x)
    x.sample(rand(0..x.length))
  end

  def impl_size(x)
    x.length
  end

  # Helper for variance, denom is different for kurtosis
  def general_var(x, denom)
    n = x.length
    return 0 if denom <= 0
    a = x.map { |e| e**2 }.reduce(:+) - @rh.r_div(x.reduce(:+)**2, n)
    @rh.r_div(a, denom)
  end

  def impl_variance(x)
    general_var(x, x.length - 1)
  end

  def impl_range(x)
    return 0 if x.empty?
    x.max - x.min
  end

  # Helper for IQR, assumes x is sorted
  def pth_quantile(x, p)
    m = (x.length + 1) * p
    return 0 if m < 1 || m > x.length
    j = m.floor
    j == m ? x[m - 1] : impl_mean(x[j - 1, 2])
  end

  def impl_iqr(x)
    y = x.sort
    upper = pth_quantile(y, 0.75)
    lower = pth_quantile(y, 0.25)
    @rh.r2n(upper - lower)
  end

  def impl_quantile(x)
    y = x.sort
    pth_quantile(y, rand.round(2))
  end

  ## This section is for functions built using those above
  #

  def impl_std(x)
    Math.sqrt(impl_variance(x))
  end

  def impl_average(x)
    impl_select([impl_mean(x), impl_median(x), impl_mode(x)])
  end

  def impl_gmdl(x)
    impl_mean(Array.new(impl_select(x).abs) { impl_average(x) })
  end

  def impl_trim(x)
    trim = impl_std(x).to_i
    trim.times { x = impl_remove(x) }
    impl_shuffle(x)
  end

  def impl_normalize(x)
    mu = impl_mean(x)
    std_dev = impl_std(x)
    return x if std_dev.zero?
    x.map { |n| (n - mu) / std_dev }
  end

  def shape_desc(x, desc)
    v = general_var(x, x.length)
    return 0 if v.zero?
    mu = impl_mean(x)
    top = x.map { |n| (n - mu)**desc }.reduce(:+)
    numerator = @rh.r_div(top, x.length)
    numerator / v**(desc / 2r)
  end

  def impl_skewness(x)
    shape_desc(x, 3)
  end

  def impl_kurtosis(x)
    shape_desc(x, 4)
  end
end
