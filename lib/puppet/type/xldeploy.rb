require 'puppet/type'

Puppet::Type.newtype :xldeploy do
  @doc = 'Manage XL Deploy server server connectivity info such as username, password, url.'

  newparam(:name, :namevar => true) do
    desc 'The name of the xldeploy server.'
  end

  newparam :username do
    desc 'username used to connect to XL Deploy server'
  end

  newparam :password do
    desc 'password used to connect to XL Deploy server'
  end

  newparam :url do
    desc 'XL Deploy server url'
    validate do |value|
      fail("Invalid url #{value}") unless URI.parse(value).is_a?(URI::HTTP)
    end
  end

  newparam :context do
    desc "specify the XL Deploy server's context root"
    defaultto '/'
  end

  newparam :version do
    desc 'XL Deploy server server version'
    defaultto '4.5.1'
  end

  newparam :encrypted_dictionary do
    desc 'dictionary used to encrypt the passwords.'
    defaultto 'Environments/PuppetModuleDictionary'
  end

end

Puppet::Type.newmetaparam(:server) do
  desc 'Provide a new metaparameter for all resources called server.'
end

