require_relative 'list_impl'
require_relative 'num_impl'
require_relative 'multi_arg_impl'
require_relative 'parse_help'

#
## Functions which take no arguments
#
class NoArgImpl
  def initialize
    @objs = [ListImpl.new, NumImpl.new({}), MultiArgImpl.new, self]
    @ph = ParseHelp.new({})
  end

  def output_name(obj)
    raw_name = obj.class.name.gsub('impl', '')
    puts "\n#{raw_name} functions:"
  end

  def impl_help
    pmeths = @objs.map do |o|
      output_name(o)
      @ph.get_methods(o).map { |m| puts m }
    end
    puts "\nType `exit` or `q` to exit"
    pmeths.flatten.count
  end

  def impl_random
    rand
  end
end
