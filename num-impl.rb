require_relative 'list-impl'
require_relative 'rational-help'

#
## Functions which take integers as input
#
class NumImpl
  def initialize
    @list = ListImpl.new
    @rh = RationalHelp.new
  end

  def Impl_twist(i)
    i < 1000 ? rand(i..1000) : rand(0..i)
  end

  def Impl_wrap(i)
    Array.new(i.abs) { rand(1000) }
  end

  # Select a random command for the input, print, and execute it
  def get_next(input)
    obj = input.is_a?(Array) ? @list : self
    meth = obj.methods.grep(/Impl/).reject { |x| x =~ /chain/ }.sample
    raw = meth.to_s.gsub('Impl_', '')
    print " -> #{raw}"
    obj.send(meth, input)
  end

  def Impl_chain(i)
    # Chain together a random sequence of i commands
    input = Impl_wrap(i)
    print 'wrap'
    i.abs.times { input = get_next(input) }
    print "\n"
    input
  end

  def Impl_coerce(i)
    i.is_a?(Rational) ? i.to_f : i.round
  end

  # Creates a generator based on the size and sign of i
  def get_gen(i)
    return -500..500 unless i.is_a?(Float) || i.abs > 500
    i > 0 ? 0..(2 * i) : (2 * i)..0
  end

  def Impl_build(i)
    # i is the mean (and median) of the dataset we are building
    length = rand(1000)
    gen = get_gen(i)

    out = Array.new(length / 2) { rand(gen) }
    out += out.map { |k| 2 * i - k }
    out += [i] if length.odd?
    out.shuffle!

    i.is_a?(Rational) ? out.map { |p| @rh.r2n(p) } : out
  end
end
