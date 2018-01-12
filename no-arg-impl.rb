require_relative 'list-impl'
require_relative 'num-impl'

#
## Functions which take no arguments
#
class NoArgImpl
  # gather a list of methods and print them
  def get_methods(obj)
    raw_name = obj.class.name.gsub('Impl', '')
    puts "\n#{raw_name} functions:"
    meths = obj.methods.grep(/Impl/)
    meths.each { |m| puts m.to_s.gsub('Impl_', '') + '!' }
  end

  def Impl_help
    objs = [ListImpl.new, NumImpl.new, self]
    count = objs.map { |o| get_methods(o) }.flatten.count
    puts "\nType `exit` or `q` to exit"
    count
  end
end
