require_relative 'parse'
require_relative 'repl'

if ARGV.include?('-s') || ARGV.include?('--string')
  @s_option = true
  ARGV.reject! { |x| %w[-s --string].include? x }
end

if ARGV.size > 1
  puts 'Usage: ruby doubleu.rb [source.doubleu] [options]'
elsif ARGV.empty?
  Repl.new.run(Main.new('', @s_option))
else
  source = File.read(ARGV.shift)

  code = Main.new(source, @s_option)

  begin
    code.run
  rescue RuntimeError => e
    warn e.message
    warn e.backtrace
  end
end
