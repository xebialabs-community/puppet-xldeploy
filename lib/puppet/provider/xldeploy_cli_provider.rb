require 'puppet'
require 'puppet_x/xebialabs/xldeploy/cli.rb'

class Puppet::Provider::XlDeployCliProvider < Puppet::Provider

  attr_accessor :ci

  def exists?
    !ci.nil?
  end

  def create
    @state = :create
    @ci = to_ci
  end

  def destroy
    @state = :destroy
  end

  def properties
    #ci.properties.select { |p| @resource[:properties].keys.include? p } not work using ruby 1.8.7
    props = {}
    ci.properties.each do |key, value|
      if @resource[:properties].keys.include? key
        props[key]=value
      end
    end

    #encrypt fields
    if props.keys.include? 'password'
      @resource[:properties]['password'] = repository.encrypt(@resource[:properties]['password'], xld_resource[:encrypted_dictionary])
    end
    if props.keys.include? 'passphrase'
      @resource[:properties]['passphrase'] = repository.encrypt(@resource[:properties]['passphrase'], xld_resource[:encrypted_dictionary])
    end

    props
  end

  def properties=(values)
    ci.properties=values
    @state = :modify
    @property_hash[:properties]=values
  end

  def communicator
    return @communicator if defined?(@communicator)
    @communicator = XLDeployCommunicator.new(xld_resource[:url], xld_resource[:username], xld_resource[:password], xld_resource[:context])
    Puppet.debug("XL Deploy Server #{@communicator}")
    @communicator
  end

  def xld_resource
    return @xld_resource if defined?(@xld_resource)
    unless @xld_resource = resource.catalog.resource("#{resource[:server]}")
      raise "Can't find #{resource[:server]}"
    end
    @xld_resource
  end

  def repository
    return @repository if defined?(@repository)
    @repository = Repository.new(communicator)
    @repository
  end

  def security
    return @security if defined?(@security)
    @security = Security.new(communicator)
    @security
  end

  def deployment
    return @deployment if defined?(@deployment)
    @deployment = Deployment.new(communicator)
    @deployment
  end

  def tasks
    return @tasks if defined?(@tasks)
    @tasks = Tasks.new(communicator)
    @tasks
  end

  def application
    return @application if defined?(@application)
    @application = Application.new(communicator)
    @application
  end

end


