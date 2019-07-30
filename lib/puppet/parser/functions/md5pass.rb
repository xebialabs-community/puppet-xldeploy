
require "yaml"

module Puppet::Parser::Functions
  newfunction(:md5pass, :type => :rvalue, :doc => <<-EOS
    encodes a string into a md5 password usable hash
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "md5pass(): Wrong number of arguments " +
      "given (#{arguments.size} for 2)") if arguments.size < 2

    value = arguments[0]
    value_class = value.class
    salt = arguments[1]
    salt_class = salt.class

    unless [String].include?(value_class) && [String].include?(salt_class)
      raise(Puppet::ParseError, 'md5pass(): Requires:' +
        'string to work with')
    end

    # set cachefilename
    cache_file = '/var/tmp/md5pass_cache.yaml'

    # create cache hash

    # get the cache from file if the file exists
    cache = YAML.load_file('/var/tmp/md5pass_cache.yaml') if File.exists?(cache_file)
    cache = {} if cache == nil
    cache = {} if cache == false

    result = cache[value] if cache.has_key?(value)
    result = `/usr/bin/openssl passwd -1 -salt #{salt} #{value}`.strip() if result == nil

    cache[value] = result


    File.open(cache_file, "w") do |f|
      YAML::dump(cache, f)
    end

    File.chmod(0600, cache_file) if File.exists?(cache_file)

    return result
  end
end
