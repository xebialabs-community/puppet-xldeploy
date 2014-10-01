require 'puppet/type'
require 'pathname'

Puppet::Type.newtype :xldeploy_environment do
  @doc = 'Manage an udm.Environment CI on XlDeploy Server.'

  newparam :id, :namevar => true do
    desc 'CI id'
  end

  newparam :type do
    desc 'CI Type'
    defaultto 'udm.Environment'
  end

  newproperty :containers, :array_matching => :all do
    desc 'CI containers'

    def insync?(is)
      #if the current definition doesn't manage containers
      return true if @should.empty?

      return false unless is.class == Array and should.class == Array

      # now lets compare the two and see is a modify is needed
      # haven't quite worked out yet what to do with extra values in the is hash
      @should.each do |k|
        # if is[k] is not equal to should[k] the insync? should return false
        return false unless is.include?(k)
      end
      return false unless is.length == @should.length
      true
    end

    defaultto []
  end

  newproperty :dictionaries, :array_matching => :all do
    desc 'CI dictionaries'

    def insync?(is)
      #if the current definition doesn't manage dictionaries
      return true if @should.empty?

      return false unless is.class == Array and should.class == Array

      # now lets compare the two and see is a modify is needed
      # haven't quite worked out yet what to do with extra values in the is hash
      @should.each do |k|
        # if is[k] is not equal to should[k] the insync? should return false
        return false unless is.include?(k)
      end
      return false unless is.length == @should.length
      true
    end

    defaultto []
  end

  autorequire(:server) do
    self[:server]
  end

  autorequire(:xldeploy_container) do
    self[:containers]
  end

  autorequire(:xldeploy_directory) do
    #Parent directory is auto-required.
    [Pathname.new(self[:id]).dirname.to_s]
  end

  ensurable do
    defaultvalues
    defaultto :present
  end

end

