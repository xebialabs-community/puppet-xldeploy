require 'pathname'

Puppet::Type.newtype(:xldeploy_role_permission) do
  @doc = 'Manage a XL Deploy Role'

  feature :restclient, 'Use REST to update XL Deploy repository'

  autorequire (:class) do
    'xldeploy'
  end

  autorequire (:xldeploy_ci) do
    self[:cis]
  end

  autorequire(:xldeploy_role) do
    self[:role]
  end

  newparam(:name, :namevar => :true) do
    desc 'The arbitrary name for this match'
  end

  newparam(:role) do
    desc 'The ID/username of the Role'
  end

  newparam(:cis, :array_matching => :all) do
    desc 'The cis to grant permissions on'
    munge do |value|
      if value.class == String
        [value]
      else
        value
      end
    end
  end

  newproperty(:granted_permissions, :array_matching => :all ) do
    desc 'The permissions this role has specified on this ci'
  end

  newparam(:rest_url, :required_features => ['restclient']) do
    desc 'The rest url for making changes to XL Deploy'
  end
end
