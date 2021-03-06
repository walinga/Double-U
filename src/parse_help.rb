# Helper class for parsing numbers, arrays, and for enforcing options
class ParseHelp
  def initialize(options, no_arg, rational_help, err)
    @noarg = no_arg
    @options = options
    @rh = rational_help
    @err = err
  end

  def error(string, args = {})
    base = ''
    if args[:var_undef]
      meths = @noarg.objs.map { |o| @noarg.get_methods(o) }
      dym = "\nDid you mean: #{args[:var_undef]}! (with a ! 'bang')"
      base += dym if meths.flatten.include?(args[:var_undef] + '!')
    end
    @err.error(string, base)
  end

  def num_regex
    %r{-?\d+((\.|/)\d+)?}
  end

  def array_regex
    /\[ *((?:#{num_regex} +)*#{num_regex}?)\]/
  end

  def check_if_definable(objs, cmd, defn)
    overlaps = objs.map { |o| @noarg.get_methods(o).include?("#{cmd}!") }
    error "#{cmd} already defined" if overlaps.any?
    error 'infinitely recursive function' if defn =~ /(?<!\w)#{cmd}!/
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

  def safe_print(val)
    error 'trying to print void' if val.nil?
    print stringify(val), "\n"
  end
end
