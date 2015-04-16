require 'pathname'
require 'puppet_x/xebialabs/xldeploy/dictionary_entry.rb'
require 'puppet_x/xebialabs/xldeploy/environment_members.rb'

Puppet::Type.type(:xldeploy_environment_member).provide :rest do

  def create
    environment_members.persist
  end

  def destroy
    environment_members.destroy
  end

  def exists?
    environment_members.environment_exists?
  end

  def members
    environment_members.current_members
  end

  def members=(value)
    environment_members.persist
  end

  def dictionaries
    environment_members.current_dictionaries
  end

  def dictionaries=(value)
    environment_members.persist
  end

  private

  def environment_members
    Environment_members.new(resource[:rest_url], resource[:env], resource[:members], resource[:dictionaries], resource[:ssl], resource[:verify_ssl])
  end
end
