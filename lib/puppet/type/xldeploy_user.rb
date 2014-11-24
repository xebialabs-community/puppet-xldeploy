Puppet::Type.newtype(:xldeploy_user) do
  @doc = 'Manage a XL Deploy User'

  feature :restclient, 'Use REST to update XL Deploy repository'

  ensurable do
    defaultvalues
    defaultto :present
  end

  autorequire (:class) do
    'xldeploy'
  end

  newparam(:id, :namevar => true) do
    desc 'The ID/username of the user'

  end

  newparam(:password) do
    desc 'Password of the user'
  end

  newparam(:rest_url, :required_features => ['restclient']) do
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
