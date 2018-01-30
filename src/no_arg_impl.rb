require_relative 'list_impl'
require_relative 'num_impl'
require_relative 'multi_arg_impl'

#
## Functions which take no arguments
#
class NoArgImpl
  def initialize
    @objs = [ListImpl.new, NumImpl.new({}), MultiArgImpl.new, self]
  end

  # Gathers a list of methods and prints them
  def get_methods(obj)
    raw_name = obj.class.name.gsub('impl', '')
    puts "\n#{raw_name} functions:"
    meths = obj.methods.grep(/impl/)
    meths.each { |m| puts m.to_s.gsub('impl_', '') + '!' }
  end

  def impl_help
    count = @objs.map { |o| get_methods(o) }.flatten.count
    puts "\nType `exit` or `q` to exit"
    count
  end

  def impl_random
    rand
  end
end
