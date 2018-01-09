require_relative 'parse'
require_relative 'repl'

if ARGV.size > 1
  puts "Usage: ruby doubleu.rb [source.doubleu]"
elsif ARGV.size == 0
  Repl.new.run
else
  source = File.read(ARGV.shift)

  code = Main.new(source)

  begin
      code.run
  rescue => e
    $stderr.puts e.message
    $stderr.puts e.backtrace
  end
end
