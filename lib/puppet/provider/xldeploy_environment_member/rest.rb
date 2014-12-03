require 'pathname'
require 'puppet_x/xebialabs/xldeploy/dictionary_entry.rb'


Puppet::Type.type(:xldeploy_environment_member).provide :rest do

  def create
    environment_member.persist
  end

  def destroy
    environment_member.destroy
  end

  def exists?
    environment_member.environment_exists?
  end

  def members
    environment_member.current_members
  end

  def members=(value)
    environment_member.persist
  end

  def dictionaries
    environment_member.current_dictionaries
  end

  def dictionaries=(value)
    environment_member.persist
  end

  private

  def environment_member
    Environment_member.new(resource[:rest_url], resource[:env], resource[:members], resource[:dictionaries], resource[:ssl], resource[:verify_ssl])
  end
end
