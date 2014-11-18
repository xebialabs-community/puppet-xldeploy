require 'puppet_x/xebialabs/xldeploy/ci.rb'
Puppet::Type.type(:xldeploy_ci).provide :rest2 do


  def create
    ci = Ci.new(resource[:rest_url], resource[:id], resource[:type], resource[:properties])
    if resource[:discovery]
      ci.run_discovery(discovery_max_wait = resource[:discovery_max_wait])
    else
      ci.persist
    end
  end

  def destroy
    ci = Ci.new(resource[:rest_url], resource[:id], resource[:type], resource[:properties])

    ci.destroy
  end

  def exists?
    p resource[:rest_url]
    ci = Ci.new(resource[:rest_url], resource[:id], resource[:type], resource[:properties])

    ci.exists?
  end

  def properties
    ci = Ci.new(resource[:rest_url], resource[:id], resource[:type], resource[:properties])

    ci.actual_properties
  end

  def properties=(value)
    ci = Ci.new(resource[:rest_url], resource[:id], resource[:type], resource[:properties])

    ci.persist
  end

  private


end
