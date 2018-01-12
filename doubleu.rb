require_relative 'parse'
require_relative 'repl'

if ARGV.size > 1
  puts 'Usage: ruby doubleu.rb [source.doubleu]'
elsif ARGV.empty?
  Repl.new.run(Main.new(''))
else
  source = File.read(ARGV.shift)

  code = Main.new(source)

  begin
    code.run
  rescue RuntimeError => e
    warn e.message
    warn e.backtrace
  end
end
