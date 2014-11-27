require 'pathname'
require 'puppet_x/xebialabs/xldeploy/dictionary_entry.rb'


Puppet::Type.type(:xldeploy_dictionary_entry).provide :rest do

  def create
    dictionary_entry.persist
  end

  def destroy
    dictionary_entry.destroy
  end

  def exists?
    dictionary_entry.key_exists?
  end

  def value
    dictionary_entry.current_value
  end

  def value=(value)
    dictionary_entry.persist
  end


  private

  def dictionary_entry

    Dictionary_entry.new(resource[:rest_url], resource[:key], resource[:value], resource[:ssl], resource[:verify_ssl])
  end
end
