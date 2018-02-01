require_relative 'rational_help'

# Helper class for parsing numbers, arrays, and for enforcing options
class ParseHelp
  def initialize(options)
    @options = options
    @user_def = []
    @rh = RationalHelp.new
  end

  def error(string)
    raise DoubleUError, "Double-u runtime error: #{string}. (line #{@linenum})"
  end

  def num_regex
    %r{-?\d+((\.|/)\d+)?}
  end

  def array_regex
    /\[ *((?:#{num_regex} +)*#{num_regex}?)\]/
  end

  def handle_no_method(e)
    raise e unless e.message.include?('impl')
    base_message = e.message.split("\n").first
    error base_message.gsub(/#<(\w+).*>/, 'type \1').gsub(/impl_?/i, '')
  end

  # Gathers a list of impl methods for obj
  def get_methods(obj)
    meths = obj.methods.grep(/impl/)
    meths.map { |m| m.to_s.gsub('impl_', '') + '!' }
  end

  def check_if_definable(objs, cmd, defn)
    overlaps = objs.map { |o| get_methods(o).include?("#{cmd}!") }
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

  def add_user_def(ud)
    @user_def << ud
  end

  def print_user_defs
    @user_def.map { |m| puts m + '!' }
  end
end
