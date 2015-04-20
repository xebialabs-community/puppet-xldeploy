
module Puppet::Parser::Functions
  newfunction(:bool2string, :type => :rvalue, :doc => <<-EOS
   takes a boolean and returns the value as a string being true or false
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "bool2string(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size != 1

    return 'true'  if arguments[0].class == TrueClass
    return 'false' if arguments[0].class == FalseClass
    return 'true'  if arguments[0] =~ /true/
    return 'false'  if arguments[0] =~ /false/





  end
end
