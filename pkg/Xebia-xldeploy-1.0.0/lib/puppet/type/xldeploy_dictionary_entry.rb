require 'pathname'

Puppet::Type.newtype(:xldeploy_dictionary_entry) do
  @doc = 'Manage a XL Deploy Dictionary Entry'

  feature :restclient, 'Use REST to update XL Deploy repository'

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

  newparam(:rest_url, :required_features => ['restclient']) do
    desc 'The rest url for making changes to XL Deploy'
  end
end
