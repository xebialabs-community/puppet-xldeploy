module Puppet::Parser::Functions
  newfunction(:random_passphrase, :type => :rvalue, :doc => <<-EOS
    returns a random 50 char string to use as a passphrase .. goodluck reading that
    off a screen ..
    EOS
  ) do |arguments|

    #passphrasefile = File.join(Puppet[:vardir],"passp.txt")
    #
    #
    #o = [('a'..'z'), ('A'..'Z'),(0..9)].map { |i| i.to_a }.flatten
    #string = (0...50).map { o[rand(o.length)] }.join
    string = 'bvarZAcpeMYZisavmUFgyl98JnQRpmzeoy2rdN5K3BgpZCBBiI'
    return string
  end
end