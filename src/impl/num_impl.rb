#
## Functions which take integers as input
#
class NumImpl
  def initialize(options, list, rational_help)
    @range = options[:restrict] ? 32..126 : 0..1000
    @list = list
    @rh = rational_help
  end

  def impl_twist(i)
    i < 1000 ? rand(i..1000) : rand(0..i)
  end

  def impl_wrap(i)
    Array.new(i.abs) { rand(@range) }
  end

  # Selects a random command for the input, prints, and executes it
  def get_next(input)
    obj = input.is_a?(Array) ? @list : self
    meth = obj.methods.grep(/impl/).reject { |x| x =~ /chain/ }.sample
    raw = meth.to_s.gsub('impl_', '')
    print " -> #{raw}"
    obj.send(meth, input)
  rescue DoubleUError
    print ' (aborted)'
    input
  end

  # Chains together a random sequence of i commands
  def impl_chain(i)
    input = impl_wrap(i)
    print 'wrap'
    i.abs.to_i.times { input = get_next(input) }
    print "\n"
    input
  end

  def impl_coerce(i)
    i.is_a?(Rational) ? i.to_f : i.round
  end

  # Creates a generator based on the size and sign of i
  def get_gen(i)
    return @range unless i.is_a?(Float) || !@range.include?(i)
    i > 0 ? 0..(2 * i) : (2 * i)..0
  end

  def impl_build(i)
    length = rand(1000)
    gen = get_gen(i)

    # The idea here is to generate random numbers and then mirror
    # each one through i (the median). This gives a symmetric dataset
    out = Array.new(length / 2) { rand(gen) }
    out += out.map { |k| 2 * i - k }
    out += [i] if length.odd?
    out.map { |p| @rh.r2n(p) }
  end

  def impl_fill(i)
    Array.new(rand(0..1000)) { i }
  end

  # Sometimes we want to treat a number as an array
  def impl_list(i)
    [i]
  end
end
