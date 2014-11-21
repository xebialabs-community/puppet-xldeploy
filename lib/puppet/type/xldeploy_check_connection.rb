Puppet::Type.newtype(:xldeploy_check_connection) do

  ensurable do
      defaultvalues
      defaultto :present
    end

  newparam(:name, :namevar => true ) do
    desc 'just a name '
  end

  newparam(:rest_url) do

    desc 'The rest url for making changes to XL Deploy'
    validate do |value|
      fail "rest_url cannot be empty" if value.nil?
    end

  end


  newparam(:timeout) do
    defaultto 240

    validate do |value|
      # This will raise an error if the string is not an integer
      Integer(value)
    end

    munge do |value|
      Integer(value)
    end
  end
end