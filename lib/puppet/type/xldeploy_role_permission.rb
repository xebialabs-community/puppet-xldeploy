require 'pathname'

Puppet::Type.newtype(:xldeploy_role_permission) do
  @doc = 'Manage a XL Deploy Role'


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

  newparam(:rest_url) do
    desc 'The rest url for making changes to XL Deploy'
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
