require 'readline'
require 'colorize'
require_relative 'parse'

# Class used to provide users with an easy-to-use REPL environment
class Repl
  def print_pink(s)
    puts s.to_s.colorize(:light_magenta)
  end

  def get_output(input, main)
    exit if input =~ /^(exit|q)$/
    # This lets the user type '_' to reference the previous result
    cmd = input =~ /print|^ *(;|$)/ ? input : "let _ = #{input}"
    main.execline cmd
  rescue DoubleUError => e
    puts e.message.red
    :error
  end

  def run(main)
    while (input = Readline.readline('>', true))
      output = get_output(input, main)
      next if output == :error
      print_pink(output) unless output.nil?
    end
  rescue Interrupt
    print "\n"
    retry
  end
end
