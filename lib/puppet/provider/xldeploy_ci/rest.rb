require_relative '../rest_provider.rb'
Puppet::Type.type(:xldeploy_ci).provide :rest, :parent => Puppet::Provider::XLDeployRestProvider do

  confine :feature => :restclient

  has_feature :restclient

  def create
    ensure_parent_directory("#{resource[:id]}")
    ci_xml = to_xml(resource[:id],resource[:type],resource[:properties])

    if resource[:discovery]
      inspection = rest_post "inspection/prepare/", ci_xml
      task_id = rest_post "inspection/", inspection
      rest_post "task/#{task_id}/start"

      max_wait = resource[:discovery_max_wait].to_i
      while max_wait > 0
        state = to_hash(rest_get "task/#{task_id}")['@state'].upcase
        case state
        when 'EXECUTED'
          break
        when 'STOPPED', 'DONE', 'CANCELLED'
          fail "Discovery of #{resource[:id]} failed, invalid inspection task #{task_id} state #{state}"
        when 'EXECUTING', 'PENDING', 'QUEUED'
          debug "Waiting for discovery to finish, task: #{task_id}, current state: #{state}, wait time left: #{max_wait}"
        end
        max_wait = max_wait - 1
        sleep 1
      end
      if max_wait == 0
        fail "Discovery of #{resource[:id]} failed, max wait time #{resource[:discovery_max_wait]} exceeded"
      end

      rest_post "task/#{task_id}/archive"
      inspection_result = rest_get "inspection/retrieve/#{task_id}"
      rest_post "repository/cis", inspection_result
    else
      rest_post "repository/ci/#{resource[:id]}", ci_xml
    end
  end

  def destroy
    rest_delete "repository/ci/#{resource[:id]}"
  end

  def exists?
    p resource[:id]
    resource_exists?(resource[:id])
  end

  def properties
    p " properties !!!"
    ci_xml = rest_get "repository/ci/#{resource[:id]}"

    ci_hash = to_hash(ci_xml)

    p "actual #{ci_hash}"
    p "desired #{resource[:properties]}"
    # Add unmanaged k/v pairs that XL Deploy returns to our properties.
    # Otherwise these will be reset when updating any other property.
    ci_hash.each do |k, v|
      p k
      p v
      resource[:properties][k] = v unless resource[:properties].include? k

      # Temporarily replace password properties as well, until we can
      # encode passwords ourselves
      resource[:properties][k] = v if (k == 'password' or k == 'passphrase') and v.start_with?('{b64}')
    end
    p " end of properties !!!"

  end

  def properties=(value)
    p "properties=!!!"
    p "#{value}"
    ci_xml = to_xml(resource[:id],resource[:type],value)
    rest_put "repository/ci/#{resource[:id]}", ci_xml
  end

  def ensure_parent_directory(id)
    # check if the parent tree parent of this ci exists.

    # get the parent name
    parent = Pathname.new(id).dirname.to_s

    # if the parent exists do nothing
    unless resource_exists?(parent)
      # ensure that the parent of this parent exists..
      # this builds a recursive loop wich loops over the entire path of the ci
      # until it finds a parent that is created
      # and will create all parents until the final one
      ensure_parent_directory(parent)

      # if the parent of this parent exists the create this one as a core.Directory
      parent_xml = to_xml(parent, 'core.Directory', {} )
      rest_post "repository/ci/#{parent}", parent_xml
    end
  end

  def resource_exists?(id)
    # check if a certain resource exists in the XL Deploy repository
    xml = rest_get "repository/exists/#{id}"
    return xml =~ /true/
  end
end
