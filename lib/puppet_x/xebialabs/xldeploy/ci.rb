require 'pathname'

require File.join(File.dirname(__FILE__), 'xldeploy')

class Ci < Xldeploy

  attr_accessor :desired_properties, :id, :type

  #initialize the ci
  # pass the rest_url for communication to xldeploy
  # id is the id in the xldeploy repo
  # type is the type of the ci
  # properties is optional.. these represent the properties in xldeploy if needed
  def initialize(rest_url,id,type, properties={}, ssl, verify_ssl)
    super(rest_url, ssl, verify_ssl)
    @id   = id
    @type = type
    @desired_properties = properties
  end

  # check wheter the ci already exists in xldeploy
  def exists?
    xml = rest_get "repository/exists/#{id}"
    return xml =~ /true/
  end

  # return the actual properties the ci has in xldeploy
  # this construct makes sure the propertys are only
  def actual_properties
    @actual_properties || @actual_properties = get_actual_properties
  end

  # fetch the actual properties if needed
  def get_actual_properties
    xml = actual_xml
    return {} if xml.nil?
    to_hash(xml)
  end

  # return the actual xml of the xldeploy ci
  def actual_xml
    @actual_xml || @actual_xml = get_actual_xml
  end

  # fetch the actual xml from xldeploy
  def get_actual_xml
    if exists?
      rest_get "repository/ci/#{id}"
    else
      nil
    end
  end

  # translate the desired properties into xml
  def desired_xml
    to_xml(id, type, desired_properties)
  end

  # persist the ci to xldeploy
  def persist
    ensure_parent_directory
    if exists?
      rest_put "repository/ci/#{id}", desired_xml
    else
      rest_post "repository/ci/#{id}", desired_xml
    end
  end


  # make sure the ci's parent structure is in place
  def ensure_parent_directory
    # check if the parent tree parent of this ci exists.

    # get the parent name
    parent = Ci.new(rest_url,Pathname.new(id).dirname.to_s, 'core.Directory')

    # if the parent exists do nothing
    unless parent.exists?
      parent.persist
    end
  end

  # returns true if an update is needed
  # this is based on difference being found between desired and actual properties
  # strict means the check goes both ways
  def update_needed?(strict = false)
    update = false
    if strict == false
      desired_properties.each {|k,v| update = true unless actual_properties[k] == v }
    else
      desired_properties.each {|k,v| update = true unless actual_properties[k] == v }
      actual_properties.each {|k,v| update = true unless desired_properties[k] == v }
    end

    return update
  end

  # this method runs a discovery on a ci
  def run_discovery(discovery_max_wait = '120')
    inspection = rest_post "inspection/prepare/", desired_xml
    task_id = rest_post "inspection/", inspection
    rest_post "task/#{task_id}/start"

    max_wait = discovery_max_wait.to_i
    while max_wait > 0
      state = get_task_state(task_id)
      case state
        when 'EXECUTED'
          break
        when 'STOPPED', 'DONE', 'CANCELLED'
          fail "Discovery of #{id} failed, invalid inspection task #{task_id} state #{state}"
        when 'EXECUTING', 'PENDING', 'QUEUED'
          p "Waiting for discovery to finish, task: #{task_id}, current state: #{state}, wait time left: #{max_wait}"
      end
      max_wait = max_wait - 1
      sleep 1
    end
    if max_wait == 0
      fail "Discovery of #{:id} failed, max wait time #{discovery_max_wait} exceeded"
    end
    rest_post "task/#{task_id}/archive"
    inspection_result = rest_get "inspection/retrieve/#{task_id}"
    if inspection_result != "No resource method found for GET, return 405 with Allow header"
      rest_post "repository/cis", inspection_result
    end
  end

end