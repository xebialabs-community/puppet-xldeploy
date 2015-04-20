module Puppet::Parser::Functions
  newfunction(:get_filename, :type => :rvalue, :doc => <<-EOS
    Returns the basename(filename) of a path.
  EOS
  ) do |arguments|

    if arguments.size < 1 then
      raise(Puppet::ParseError, "dirname(): No arguments given")
    end
    if arguments.size > 1 then
      raise(Puppet::ParseError, "dirname(): Too many arguments given (#{arguments.size})")
    end
    unless arguments[0].is_a?(String)
      raise(Puppet::ParseError, 'dirname(): Requires string as argument')
    end

    return File.basename(arguments[0])

  end
end
