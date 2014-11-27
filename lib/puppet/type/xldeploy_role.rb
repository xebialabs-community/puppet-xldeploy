require 'pathname'

Puppet::Type.newtype(:xldeploy_role) do
  @doc = 'Manage a XL Deploy Role'


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

  newparam(:rest_url) do
    desc 'The rest url for making changes to xldeploy'
  end

  newparam(:ssl) do
    desc 'indicate if ssl should be used'

    defaultto false

    validate do |value|
      fail 'ssl should be true or false' unless value.is_a? TrueClass or FalseClass
    end
  end

  newparam(:verify_ssl) do
    desc 'if set to true the offerd certificate from the server will always be accepted'

    defaultto true

    validate do |value|
      fail 'ssl should be true or false' unless value.is_a? TrueClass or FalseClass
    end

  end
end
