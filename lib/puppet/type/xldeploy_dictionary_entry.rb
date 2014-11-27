require 'pathname'

Puppet::Type.newtype(:xldeploy_dictionary_entry) do
  @doc = 'Manage a XL Deploy Dictionary Entry'


  ensurable do
    defaultvalues
    defaultto :present
  end

  autorequire (:class) do
    'xldeploy'
  end

  autorequire (:xldeploy_ci) do
    # Add parent (dictionary) as required
    Pathname.new(self[:key]).dirname.to_s
  end

  newparam(:key, :namevar => true) do
    desc 'The name of the dictionary entry, must be unique'
  end

  newproperty(:value) do
    desc 'Value of the dictionary entry'

    # Temporarily overwrite insync?, until we can
    # encode passwords ourselves
    def insync?(is)
      is.start_with?('e{{b64}') or is == @should.first
    end
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
