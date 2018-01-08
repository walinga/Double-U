require_relative 'list-impl'
require_relative 'num-impl'
require_relative 'no-arg-impl'

class DoubleUError < Exception
end

class Main

  def initialize(src)
    @src = src
    @list = ListImpl.new
    @num = NumImpl.new
    @noarg = NoArgImpl.new
    @vars = {} # Hash table of variables
    @linenum = 1 # variable; used for error messages
  end

  def error(string)
    raise DoubleUError, "Double-u syntax error: #{string}. (line #{@linenum})"
  end

  def checkDef(var) 
    unless @vars.has_key?(var)
      error "Variable #{var} undeclared"
    end
  end

  def findType(var, func)
    if var.kind_of?(Array)
      @list
    elsif var.kind_of?(Numeric)
      @num
    else
      error "Invalid argument to function #{func}"
    end
  end

  def callFunction(input, name)
    findType(input, name).send("Impl_#{name}" ,input)
  end

  def execline(inst)
    case inst.strip.downcase
      when /^$/  # Blank space
      when /^;.*$/ # Comment
      when /^(.*);.*$/
        execline($1.strip)
      when /^\((.*)\)$/
        execline($1.strip)
      when /^let +(\w+) *= *\[ *((\d *)*)\]$/
        @vars[$1] = $2.split.map { |x| x.to_i }
      when /^let +(\w+) *= *(\d+)$/
        @vars[$1] = $2.to_i
      # Expression as rvalue for 'let'
      when /^let +(\w+) *= *(.*)$/
        val = execline($2)
        error "trying to assign void to a variable" if val.nil?
        @vars[$1] = val
      # Note: printing literals is prohibited
      when /^print +(\w+)$/
        checkDef($1)
        print @vars[$1], "\n"
      when /^print +(.*)$/
        val = execline($1)
        error "trying to print void" if val.nil?
        print val, "\n"
      when /^merge +(\w+) (\w+)$/
        checkDef($1)
        checkDef($2)
        a1, a2 = @vars[$1], @vars[$2]
        if findType(a1, "merge") != findType(a2,"merge")
          error "Type inputs to merge don't match"
        end
        a1 + a2
      # Num function with literal as param
      when /^([a-z]+)! *(\d+)$/
        eval "@num.Impl_#{$1}(#{$2})"
      # Any function with variable as param
      when /^([a-z]+)! +(\w+)$/
        checkDef($2)
        callFunction(@vars[$2], $1)
      # List function with literal as param
      when /^([a-z]+)! *\[ *((\d *)*)\]$/
        eval "@list.Impl_#{$1}(#{$2.split.map { |x| x.to_i}})"
      # No arg function
      when /^([a-z]+)!$/
        eval "@noarg.Impl_#{$1}"
      # Any function with result of another function as param
      when /^([a-z]+)! +(.*)$/
        callFunction(execline($2), $1)
      # Just a literal var. Allows "let x = y"
      when /^(\w+)$/
        checkDef($1)
        @vars[$1]
      else
        error "Invalid instruction"
    end
  rescue NoMethodError => e
    error e.message.split("\n").first.gsub('Impl_', '').gsub(/#<.*>/, 'given type')
  end

  def run
    if @src[0] == '`'
      print @src[1..-1]
      exit
    end

    # Since Double-U is a command-based language, we parse each line separately
    @src.split("\n").each do |inst|
      execline inst
      @linenum += 1
    end

  end
end
