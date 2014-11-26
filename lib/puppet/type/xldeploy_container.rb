require 'puppet/type'
require 'pathname'

Puppet::Type.newtype :xldeploy_container do
  @doc = 'Manage an udm.Container on XL Deploy Server.'

  newparam :id, :namevar => true do
    desc 'CI id'
  end

  newparam :type do
    desc 'CI Type'
  end

  newproperty :properties do
    desc 'CI Properties'

    def insync?(is)
      return false unless is.class == Hash and @should.first.class == Hash
      return false unless is.length == @should.first.length

      @should.first.each do |k, v|
        #convert .to_s to handle Fixnum
        return false unless is.has_key? k and is[k]==@should.first[k].to_s
      end
      true
    end

  end

  newproperty :tags, :array_matching => :all do
    desc 'CI tags'

    def insync?(is)
      return false unless is.class == Array and should.class == Array
      return false unless is.length == @should.length

      @should.each do |k|
        return false unless is.include?(k)
      end
      true
    end

    defaultto []
  end

  newproperty :environments, :array_matching => :all do
    desc 'Environment Id on which the container needs to be attached'
    defaultto []
  end

  autorequire(:server) do
    self[:server]
  end

  autorequire(:xldeploy_environment) do
    self[:environments]
  end

  autorequire(:xldeploy_directory) do
    #Parent directory is auto-required.
    [Pathname.new(self[:id]).dirname.to_s]
  end

  autorequire(:xldeploy_container) do
    #Parent container is auto-required.
    [Pathname.new(self[:id]).dirname.to_s]
  end

  ensurable do
    defaultvalues
    defaultto :present
  end

end

