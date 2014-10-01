require 'puppet/type'
require 'pathname'

Puppet::Type.newtype :xldeploy_directory do
  @doc = 'a core.Directory on XlDeploy Server.'

  newparam :id, :namevar => true do
    desc 'CI id'
  end

  newparam :type do
    desc 'CI Type'
    defaultto 'core.Directory'
  end

  autorequire(:server) do
    self[:server]
  end

  ensurable do
    defaultvalues
    defaultto :present
  end

  autorequire(:xldeploy_directory) do
    #Parent directory is auto-required.
    [Pathname.new(self[:id]).dirname.to_s]
  end

end

