require_relative 'rational_help'

# Helper class for parsing numbers, arrays, and for enforcing options
class ParseHelp
  def initialize(options)
    @options = options
    @rh = RationalHelp.new
  end

  def error(string)
    raise DoubleUError, "Double-u runtime error: #{string}. (line #{@linenum})"
  end

  def numify(inst)
    return inst unless @options[:string]
    # The 'S' option converts all strings to arrays of ints (like char*'s in C)
    inst.gsub(/(['"]).*?\1/) { |s| s[1..-2].unpack('C*').to_s }.delete(',')
  end

  def stringify(a)
    # The 'P' option formats output arrays as strings
    @options[:print] && a.is_a?(Array) ? a.pack('C*') : a
  end

  def to_num(s)
    error 'division by zero' if s =~ %r{/0$}
    s.include?('.') ? s.to_f : @rh.r2n(s.to_r)
  end

  def to_list(s)
    s[1..-2].split.map { |x| to_num(x) }
  end
end
