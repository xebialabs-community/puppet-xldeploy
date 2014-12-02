require 'rubygems'
require 'yaml'
require 'fileutils'
require File.join(File.dirname(__FILE__),'../../../puppet_x/xebialabs/xldeploy/', 'password')
 module Puppet::Parser::Functions
  newfunction(:to_xldeploy_md5, :type => :rvalue, :doc => <<-EOS
   Returns a deployit specific password hash when fed a plain text string
   EOS
  ) do |arguments|
    
    # check the input . we can handle 2 arguments
    raise(Puppet::ParseError, "to_xldeploy_md5(): Wrong number of arguments " +
      "given (#{arguments.length} for at least 2)") if arguments.length < 2
    raise(Puppet::ParseError, "to_xldeploy_md5(): Wrong number of arguments " +
      "given (#{arguments.length} for 4)") if arguments.length > 4



    passwordString  = arguments[0]
    restUrl         = arguments[1]
    ssl             = arguments[2] || false
    verify_ssl      = arguments[3] || true

    # this bit added for spec testing purposes ..
    baseDir         = Puppet[:vardir]
    if baseDir == '/dev/null'
      baseDir = '/tmp'
    end


    passDirName = File.join(baseDir, "deployitdir")
    yamlIndexName=File.join(passDirName, "index.yaml")

    # create keys dir under puppet files if none exists
    unless File.directory?(passDirName)
      FileUtils.mkdir_p(passDirName) unless passDirName =~ /null/
    end

    # create yaml index linking arguments to keys

    cache = YAML.load_file(yamlIndexName) if File.exists?(yamlIndexName)
    cache = {} if cache == nil

    unless cache.has_key?(passwordString)
      p "testing to_xldeploy_md5"
      # check if deployit is reachable

      pw = Password.new(restUrl, passwordString, ssl, verify_ssl)

      if pw.reachable?
        # if so .. do the translate thingy
        hashedPassword = pw.translate

        # register the hashed password in the yaml
        cache[passwordString] = hashedPassword
      else
        # if deployit is not reachable return the input string .
        # it will work in most use-cases..
        # we do not cache it ofcourse .. that would be dumb
        hashedPassword = passwordString
      end
    else

      # return the key from the cache
      hashedPassword = cache[passwordString]

    end

    #dump the cach back to file
    File.open(yamlIndexName, "w") do |f|
      YAML::dump(cache, f)
    end

    #change the mode of the indexfile to something only we can read
    File.chmod(0600, yamlIndexName) if File.exists?(yamlIndexName)

    return hashedPassword

   end
 end


