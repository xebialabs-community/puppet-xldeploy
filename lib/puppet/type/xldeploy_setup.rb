require 'pathname'

Puppet::Type.newtype(:xldeploy_setup) do

  desc 'initialize xldeploy'

  ensurable do
    desc ""

    defaultto(:present)

    newvalue(:present) do
      provider.create
    end

  end

  newparam(:name, namevar => true) do
    desc 'just some random name'
  end

  newparam(:homedir) do
    desc 'destination of the extraction operation'
    validate do |value|

      fail('invalid pathname') unless Pathname.new(value).absolute?
    end
  end

  newparam(:owner) do
    desc 'the owner setting of the license file'
    defaultto 'xldeploy'
  end

  newparam(:group) do
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
  newparam(:packages_loc) do
    desc 'location of the repository'
    defaultto 'packages'
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