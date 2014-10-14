require 'puppet/provider/xldeploy_cli_provider'

Puppet::Type.type(:xldeploy_environment).provide :rest, :parent => Puppet::Provider::XlDeployCliProvider do
  @doc = 'Manage XlDeploy environment CI using http protocol'

  def to_ci
    ci = ConfigurationItem.new(@resource[:type], @resource[:id])
    ci.properties['members']=@resource[:containers]
    ci.properties['dictionaries']=@resource[:dictionaries]
    ci
  end

  def containers
    ci['members'].sort || :absent
  end

  def containers=(values)
    ci['members']=values
    @state = :modify
  end

  def dictionaries
    ci['dictionaries'].sort || :absent
  end

  def dictionaries=(values)
    ci['dictionaries']=values
    @state = :modify
  end

  def self.prefetch(resources)
    resources.each do |name, resource|
      Puppet.debug("prefetching for #{name} id #{resource[:id]} provider #{resource.provider}")
      ci = resource.provider.repository.read(resource[:id]) if resource.provider.repository.exists?(resource[:id])
      Puppet.debug " actual state ci #{ci}"
      resource.provider.ci = ci
    end
  end

  def flush
    Puppet.debug "Flush #{resource[:id]} #{@state}"
    case @state
      when :destroy
        Puppet.debug "Delete ci #{resource[:id]} "
        repository.delete @resource[:id]
      when :create
        Puppet.debug "Create ci #{resource[:id]} "
        repository.create ci
      when :modify
        Puppet.debug "Modify ci #{resource[:id]} "
        repository.update ci
    end
  end


end

