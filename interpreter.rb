require_relative 'parse'

if ARGV.size == 0
  puts "Usage: ruby interpreter.rb source.doubleu [args ...]"
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
