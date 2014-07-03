require 'pathname'

Puppet::Type.newtype(:xldeploy_role) do
  @doc = 'Manage a Deployit Role'

  feature :restclient, 'Use REST to update the XL Deploy repository'

  ensurable do
    defaultvalues
    defaultto :present
  end

  autorequire (:class) do
    'xldeploy'
  end

  autorequire (:xldeploy_ci) do
    self[:granted_permissions].keys if self[:granted_permissions].is_a? Hash
  end

  autorequire (:xldeploy_user) do
    self[:users]
  end

  newparam(:id, :namevar => true) do
    desc 'The ID/username of the Role'
  end

  newproperty(:granted_permissions ) do
    desc 'The permissions this user has specified as ci => permission'
  end

  newproperty(:users, :array_matching => :all ) do
    desc 'The users associated with this role'
  end

  newparam(:rest_url, :required_features => ['restclient']) do
    desc 'The rest url for making changes to xldeploy'
  end
end
