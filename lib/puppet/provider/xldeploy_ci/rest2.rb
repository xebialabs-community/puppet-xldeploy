require 'puppet_x/xebialabs/xldeploy/ci.rb'
Puppet::Type.type(:xldeploy_ci).provide :rest2 do


  def create

    if resource[:discovery]
      ci.run_discovery(discovery_max_wait = resource[:discovery_max_wait])
    else
      ci.persist
    end
  end

  def destroy
    ci.destroy
  end

  def exists?
    ci.exists?
  end

  def properties

    ci_hash = ci.actual_properties

    # Add unmanaged k/v pairs that XL Deploy returns to our properties.
    # Otherwise these will be reset when updating any other property.
    ci_hash.each do |k, v|
      resource[:properties][k] = v unless resource[:properties].include? k

      # Temporarily replace password properties as well, until we can
      # encode passwords ourselves
      resource[:properties][k] = v if (k == 'password' or k == 'passphrase') and v.start_with?('{b64}')
    end
    ci_hash

  end

  def properties=(value)
    ci.persist
  end

  private

  def ci
    @ci || @ci = get_ci
  end
  def get_ci
     Ci.new(resource[:rest_url], resource[:id], resource[:type], resource[:properties])
  end
end
