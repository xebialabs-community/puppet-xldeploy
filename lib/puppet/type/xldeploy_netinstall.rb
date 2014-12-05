require 'pathname'

Puppet::Type.newtype(:xldeploy_netinstall) do

  desc 'download and unpack an XL Deploy archive file'

  ensurable do
    desc "xldeploy_netinstall resource state"

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

  newparam(:destinationdir) do
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
    desc 'the owner setting of the license file'
    defaultto 'xldeploy'
  end

  newproperty(:group) do
    desc 'the group setting of the license file'
    defaultto 'xldeploy'
  end

  newparam(:ssl) do
    desc 'use ssl or not'
    defaultto false
  end

  newparam(:repository_loc) do
    desc 'location of the repository'
    defaultto 'repository'
  end

  newparam(:admin_password) do
    desc 'admin password'
    defaultto 'admin01'
  end

  newparam(:http_content_root) do
    desc 'the content root xldeploy is going to be listening to'
    defaultto '/'
  end

  newparam(:http_bind_address) do
    desc 'the address xldeploy is going to listen on'
    defaultto '0.0.0.0'
  end

  newparam(:http_port) do
    desc 'the http port xldeploy is going to listen on'
  end

end