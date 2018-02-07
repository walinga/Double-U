#
## Functions which take no arguments
#
class NoArgImpl
  def initialize(objs)
    @objs = objs << self
    @user_def = []
  end

  attr_reader :objs

  def add_user_def(ud)
    @user_def << ud
  end

  def print_user_defs
    @user_def.map { |m| puts m + '!' }
  end

  # Gathers a list of impl methods for obj
  def get_methods(obj)
    meths = obj.methods.grep(/impl/)
    meths.map { |m| m.to_s.gsub('impl_', '') + '!' }
  end

  def output_name(obj)
    raw_name = obj.class.name.gsub('Impl', '')
    puts "\n#{raw_name} functions:"
  end

  def impl_help
    pmeths = @objs.map do |o|
      output_name(o)
      get_methods(o).map { |m| puts m }
    end
    puts "\nUser defined functions:"
    user_defs = print_user_defs
    puts "\nType `exit` or `q` to exit"
    pmeths.flatten.count + user_defs.count
  end

  def impl_random
    rand
  end
end
