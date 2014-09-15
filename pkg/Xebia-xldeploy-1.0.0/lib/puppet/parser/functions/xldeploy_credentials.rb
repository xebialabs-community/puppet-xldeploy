module Puppet::Parser::Functions
    newfunction(:xldeploy_credentials, :type => :rvalue ) do |arguments|

    raise(Puppet::ParseError, "xldeploy_credentials(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1 or arguments.size > 2

    config_file   = nil
    default_value = nil
    return_value  = nil
    config        = nil


    value         = arguments[0]
    klass         = value.class
    default_value = arguments[1] unless arguments.size < 2
    
    unless [String].include?(klass)
      raise(Puppet::ParseError, 'xldeploy_credentials(): Requires:' +
        'string to work with')
    end


    # load config file 
    if Puppet.settings[:xldeploy_config].is_a?(String)
        expanded_config_file = File.expand_path(Puppet.settings[:xldeploy_config])
        if File.exist?(expanded_config_file)
          config_file = expanded_config_file
        end
      elsif Puppet.settings[:confdir].is_a?(String)
        expanded_config_file = File.expand_path(File.join(Puppet.settings[:confdir], '/xldeploy.yaml'))
        if File.exist?(expanded_config_file)
          config_file = expanded_config_file
        end
      end
      
    # get a yaml from the configfile if it existed
    config = YAML.load_file(config_file) unless config_file == nil


    if config != nil 
        
        if config.has_key?(value)
          return_value = config["#{value}"] 
        end
    end

    if return_value == nil and default_value == nil 
      raise(Puppet::ParseError, 'xldeploy_credentials(): No credentials found in config' +
        'and no default supplied')
    else
      return_value = default_value
    end

    return return_value

 end    
end
