require 'optparse'

require_relative 'parse'
require_relative 'repl'

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: ruby doubleu.rb [source.doubleu] [options]'

  opts.on('-s', '--string', 'Convert strings to int arrays') do |s|
    options[:string] = s
  end

  opts.on('-p', '--print', 'Outputs num arrays as strings') do |p|
    options[:print] = p
  end

  opts.on('-r', '--restrict', 'Uses printable ascii ints to make arrays') do |r|
    options[:restrict] = r
  end
end.parse!

if ARGV.empty?
  Repl.new.run(Main.new('', options))
else
  source = File.read(ARGV.shift)

  code = Main.new(source, options)

  begin
    code.run
  rescue RuntimeError => e
    warn e.message
    warn e.backtrace
  end
end
