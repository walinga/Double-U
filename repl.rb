require 'readline'
require 'colorize'
require_relative 'parse'

class Repl

  def print_pink(s)
    puts s.to_s.colorize(:light_magenta)
  end

  def run
    w = Main.new('')
    output = ''

    while input = Readline.readline('>', true)
      begin
        prev_pretty = output.to_s.gsub(',', '')
        output = w.execline input.gsub('_', prev_pretty)
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
  rescue Interrupt
    print "\n"
    retry
  end   

end
