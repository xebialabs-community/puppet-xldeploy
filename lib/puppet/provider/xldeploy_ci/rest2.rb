require 'puppet_x/xebialabs/xldeploy/ci.rb'
Puppet::Type.type(:xldeploy_ci).provide :rest2 do

  def initialize(*args)
    super
    p resource
    @ci = Ci.new(resource[:rest_url], resource[:id], resource[:type], resource[:properties])
  end
  def create

    if resource[:discovery]
      @ci.run_discovery(discovery_max_wait = resource[:discovery_max_wait])
    else
      @ci.persist
    end
  end

  def destroy
    @ci.destroy
  end

  def exists?
    @ci.exists?
  end

  def properties
    @ci.actual_properties
  end

  def properties=(value)
    ci.persist
  end


end
