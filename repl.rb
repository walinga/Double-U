require 'readline'
require 'colorize'
require_relative 'parse'

def print_pink(s)
  puts s.to_s.colorize(:light_magenta)
end

w = Main.new('')

loop do
  begin
    output = w.execline Readline.readline(">", true)
  rescue DoubleUError => e
  	puts e.message.red
  	next
  end
  if output.nil? 
  	puts "nil"
  else
  	print_pink output
  end
end 
