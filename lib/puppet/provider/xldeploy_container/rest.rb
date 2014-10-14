require 'puppet/provider/xldeploy_cli_provider'

Puppet::Type.type(:xldeploy_container).provide :rest, :parent => Puppet::Provider::XlDeployCliProvider do
  @doc = 'Manage XL Deploy container CI'

  attr_accessor :envs
  attr_accessor :new_envs

  def to_ci
    ci = ConfigurationItem.new(@resource[:type], @resource[:id])
    ci.properties = @resource[:properties]
    ci.properties['tags']=@resource[:tags]
    ci
  end

  def tags
    ci['tags'].sort || :absent
  end

  def tags=(values)
    ci['tags']=values
    @state = :modify
  end

  def environments
    envs
  end

  def environments=(values)
    @state = :modify
    @new_envs = values
  end

  def self.prefetch(resources)
    #TODO: one single request to search_by_type('udm.Environment').
    resources.each do |name, resource|
      Puppet.debug("prefetching for #{name} id #{resource[:id]} provider #{resource.provider}")
      ci = resource.provider.repository.read(resource[:id]) if resource.provider.repository.exists?(resource[:id])
      Puppet.debug " ci #{ci}"
      envs = resource.provider.repository.search_by_type('udm.Environment').select { |id|
        resource.provider.repository.read(id)['members'].include? ci.id
      } if ci
      Puppet.debug " envs #{envs}"
      resource.provider.ci = ci
      resource.provider.envs = envs
    end
  end

  def flush
    Puppet.debug "Flush #{resource[:id]} #{@state}"
    case @state
      when :destroy
        @resource[:environments].each { |id|
          ci = repository.readOrCreate(id, 'udm.Environment')
          Puppet.debug("Remove from environment #{id}")
          ci['members'].delete(resource[:id])
          repository.update ci
        }
        Puppet.debug "Delete ci #{resource[:id]} "
        repository.delete @resource[:id]
      when :create
        Puppet.debug "Create ci #{resource[:id]} "
        repository.create ci
        @resource[:environments].each { |id|
          ci = repository.readOrCreate(id, 'udm.Environment')
          ci['members'] << resource[:id]
          Puppet.debug("Add to environment #{id}")
          repository.update ci
        }
      when :modify
        Puppet.debug "Modify ci #{resource[:id]} "
        repository.update ci

        new_envs - envs.each { |id|
          Puppet.debug(" Remove from environment #{id} --> #{ci.id}")
          e = repository.readOrCreate(id, 'udm.Environment')
          e['members'].delete ci.id
          repository.update e
        } if new_envs
        envs - new_envs.each { |id|
          Puppet.debug(" Update the environment #{id} --> #{ci.id}")
          e = repository.readOrCreate(id, 'udm.Environment')
          e['members'] << ci.id
          repository.update e
        } if new_envs

    end
  end


end

