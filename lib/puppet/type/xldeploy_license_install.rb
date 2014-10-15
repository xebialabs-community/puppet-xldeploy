require 'pathname'

Puppet::Type.newtype(:xldeploy_license_install) do

  desc 'Download an XL Deploy license file from the XebiaLabs download site'

  ensurable do
    desc "xldeploy_license_install resource state"

    defaultto(:present)

    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end
  end

  newparam(:url, :namevar => true) do
    desc 'the url of the required archive'
  end

  newparam(:destinationdirectory) do
    desc 'destination of the extraction operation'
    validate do |value|

      fail('invalid pathname') unless Pathname.new(value).absolute?
    end
  end

  newparam(:proxy_url) do
    desc 'http proxy url'
  end

  newparam(:user) do
    desc 'download user'
    defaultto 'download'
  end

  newparam(:password) do
    desc 'download password'
    validate do |value|
      fail('xebialabs download password should be set') if value.nil?
    end
  end

  newproperty(:owner) do
    desc 'the owner setting of the destination'
    defaultto 'xldeploy'
  end

  newproperty(:group) do
    desc 'the group setting of the destination'
    defaultto 'xldeploy'
  end

end