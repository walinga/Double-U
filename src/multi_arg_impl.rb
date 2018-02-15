
#
## Functions which take multiple arguments
## Every function should accept both [[],[]] or [1,2,3]
#
class MultiArgImpl
  def initialize(rational_help, list)
    @rh = rational_help
    @list = list
  end

  def impl_merge(vals)
    vals.reduce(:+)
  end

  def impl_difference(vals)
    vals.reduce(:-)
  end

  def throw_cov_error
    raise DoubleUError, 'Too many arguments to cov/corr (2 required)'
  end

  def cov_calc(vals)
    m1, m2 = vals.sort_by!(&:length)
    x_ = @list.impl_mean(m1)
    y_ = @list.impl_mean(m2)
    t = m1.zip(m2).map { |x, y| (x - x_) * (y - y_) }.reduce(:+)
    @rh.r_div(t, m1.length - 1)
  end

  def impl_cov(vals)
    # We can assume that vals will have length at least 2
    throw_cov_error if vals.first.is_a?(Array) && vals.length > 2
    return @list.impl_variance(vals) if vals.first.is_a?(Numeric)
    return 0 if vals.map(&:length).min <= 1
    cov_calc(vals)
  end

  def impl_corr(vals)
    return @list.impl_std(vals) if vals.first.is_a?(Numeric)
    denom = (@list.impl_std(vals.first) * @list.impl_std(vals[1]))
    return 0 if denom.zero?
    impl_cov(vals) / denom
  end
end
