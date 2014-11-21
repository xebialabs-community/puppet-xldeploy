require 'rubygems'
require 'yaml'
require 'fileutils'
require 'uri'
require 'socket'
require 'timeout'
require 'puppet_x/xebialabs/xldeploy/password.rb'

 module Puppet::Parser::Functions
  newfunction(:to_xldeploy_md5, :type => :rvalue, :doc => <<-EOS
   Returns a deployit specific password hash when fed a plain text string
   EOS
  ) do |arguments|
    
    # check the input . we can handle 2 arguments
    raise(Puppet::ParseError, "to_xldeploy_md5(): Wrong number of arguments " +
      "given (#{arguments.length} for 2)") if arguments.length < 2 
    raise(Puppet::ParseError, "to_xldeploy_md5(): Wrong number of arguments " +
      "given (#{arguments.length} for 2)") if arguments.length > 2

    passwordString  = arguments[0]
    restUrl         = arguments[1]

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

      # check if deployit is reachable

      if deployit_reachable?(restUrl)

        # if so .. do the translate thingy
        hashedPassword = translate_to_deployit_hash(restUrl, passwordString)

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

def deployit_reachable?(restUrl)
  uri = URI(restUrl)

  begin
    Timeout::timeout(1) do
      begin
        s = TCPSocket.new(uri.host, uri.port)
        s.close
        return true
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
        return false
      end
    end
  rescue Timeout::Error
  end

  return false
end

def translate_to_deployit_hash(restUrl, passwordString)
  tmpDict         = 'Environments/puppet_tmp_dict'
  deployitType    = 'udm.EncryptedDictionary'

  #compose the xml
  xml = to_xml(tmpDict, deployitType, {'entries' => {"@key" =>passwordString, "content" => passwordString}})

  # create the dictionary in deployit
  rest_post(restUrl, "repository/ci/#{tmpDict}", xml)

  # get the dictionary from deployit
  output = rest_get(restUrl, "repository/ci/#{tmpDict}")

  # extract the passwordhash from te dictionary
  passwordHash = to_ruby_hash(output)['entries']['content']

  # remove the dictionary
  rest_delete(restUrl, "repository/ci/#{tmpDict}" )

  # return the hash
  # we have to cut the first two and de last char of the bloody thing .. just because the deployit
  # rest interface is soo bloody crap
  return passwordHash[2..-2]
end

def rest_get(restUrl, service)
  RestClient.get "#{restUrl}/#{service}", {:accept => :xml, :content_type => :xml }
end

def rest_post(restUrl,service, body='')
  RestClient.post "#{restUrl}/#{service}", body, {:content_type => :xml }
end

def rest_delete(restUrl,service)
  RestClient.delete "#{restUrl}/#{service}", {:accept => :xml, :content_type => :xml }
end

def to_xml(id, type, properties)
  props = {'@id' => id}.merge(properties)
  XmlSimple.xml_out(
      props,
      {
          'RootName'   => type,
          'AttrPrefix' => true,
          'GroupTags'  => {
              'tags'         => 'value',
              'servers'      => 'ci',
              'members'      => 'ci',
              'dictionaries' => 'ci',
              'entries'      => 'entry'
          },
      }
  )
end

def to_ruby_hash(xml)

  XmlSimple.xml_in(
      xml,
      {
          'ForceArray' => false,
          'AttrPrefix' => true,
          'GroupTags'  => {
              'tags'         => 'value',
              'servers'      => 'ci',
              'members'      => 'ci',
              'dictionaries' => 'ci',
              'entries'      => 'entry'
          },
      }
  )
end
