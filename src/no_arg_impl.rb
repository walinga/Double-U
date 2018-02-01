require_relative 'list_impl'
require_relative 'num_impl'
require_relative 'multi_arg_impl'

#
## Functions which take no arguments
#
class NoArgImpl
  def initialize(parse_help)
    @objs = [ListImpl.new, NumImpl.new({}), MultiArgImpl.new, self]
    @ph = parse_help
  end

  def output_name(obj)
    raw_name = obj.class.name.gsub('Impl', '')
    puts "\n#{raw_name} functions:"
  end

  def impl_help
    pmeths = @objs.map do |o|
      output_name(o)
      @ph.get_methods(o).map { |m| puts m }
    end
    puts "\nUser defined functions:"
    user_defs = @ph.print_user_defs
    puts "\nType `exit` or `q` to exit"
    pmeths.flatten.count + user_defs.count
  end

  def impl_random
    rand
  end
end
