require 'pathname'
require File.join(File.dirname(__FILE__), 'xldeploy')

class Environment_members < Xldeploy


  def initialize(rest_url, environment, members, dictionaries, ssl = false , verify_ssl = true)
    super(rest_url, ssl, verify_ssl)
    @environment = environment
    @members = members
    @dictionaries = dictionaries
    @current_environment_properties = get_environment
  end

  def get_environment
    if environment_exists?
      env_xml = rest_get "repository/ci/#{@environment}"
      return to_hash(env_xml)
    else
      return {"members"=>[], "dictionaries"=>[], "triggers"=>[]}
    end
  end

  def dictionaries_correct?
    @dictionaries.each {|d| return false unless @current_environment_properties['dictionaries'].include? d}
    return true
  end

  def members_correct?
    @members.each {|d| return false unless @current_environment_properties['members'].include? d}
    return true
  end

  def current_dictionaries
    get_environment["dictionaries"]
  end

  def current_members
    get_environment["members"]
  end

  def environment_exists?
    ci_exists?(@environment)
  end

  def persist
      environment_properties = get_environment

      unless members_correct?
        environment_properties["members"].concat(@members)
      end

      unless dictionaries_correct?
        environment_properties["dictionaries"].concat(@dictionaries)
      end

      env_xml = to_xml(@environment, "udm.Environment", environment_properties)
      if environment_exists?
        rest_put "repository/ci/#{@environment}", env_xml
      else
        rest_post "repository/ci/#{@environment}", env_xml
      end

  end

  def destroy

    environment_properties = get_environment

    @members.each {|m| environment_properties['members'].delete(m)}
    @dictionaries.each {|d| environment_properties['dictionaries'].delete(d)}

    env_xml = to_xml(@environment, "udm.Environment", environment_properties)

    if environment_exists?
      rest_put "repository/ci/#{@environment}", env_xml
    else
      rest_post "repository/ci/#{@environment}", env_xml
    end

  end
end

