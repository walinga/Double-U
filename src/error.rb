class DoubleUError < RuntimeError
end

# Helper class for runtime-related errors
class ErrorHelp
  def initialize
    @linenum = 1
  end

  def error(string, extra = '')
    base = "Double-u runtime error: #{string}. (line #{@linenum})"
    raise DoubleUError, base + extra
  end

  def handle_no_method(e)
    raise e unless e.message.include?('impl')
    base_message = e.message.split("\n").first
    error base_message.gsub(/#<(\w+).*>/, 'type \1').gsub(/impl_?/i, '')
  end

  def update_linenum
    @linenum += 1
  end
end
