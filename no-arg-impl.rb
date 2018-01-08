require_relative 'list-impl.rb'
require_relative 'num-impl.rb'

class NoArgImpl

  def Impl_help
    objs = [ListImpl.new, NumImpl.new, self]
    count = 0
    objs.each do |obj|
      raw_name = obj.class.name.gsub('Impl','')
      puts "\n#{raw_name} functions:"
      meths = obj.methods.grep(/Impl/)
      meths.each { |m| puts (m.to_s.gsub('Impl_','') + '!') }
      count += meths.count
    end
    count
  end

end