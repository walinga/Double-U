require 'readline'
require 'colorize'
require_relative 'parse'

class Repl

  def print_pink(s)
    puts s.to_s.colorize(:light_magenta)
  end

  def run
    w = Main.new('')

    while input = Readline.readline('>', true)
      begin
        # This lets the user type '_' to reference the previous result
        output = w.execline "let _ = #{input}"
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
