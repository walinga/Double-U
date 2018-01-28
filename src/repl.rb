require 'readline'
require_relative 'parse'

# Patching here saves us having to require a dependency
class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def pink
    colorize(35)
  end
end

# Class used to provide users with an easy-to-use REPL environment
class Repl
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
      puts output.to_s.pink unless output.nil?
    end
  rescue Interrupt
    print "\n"
    retry
  end
end
