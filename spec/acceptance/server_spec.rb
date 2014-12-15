require 'spec_helper_acceptance'
require 'pry'

describe 'server:', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do


  it 'test loading class with no parameters' do
    pp = <<-EOS.unindent
    node default {
      class { 'xldeploy::server':
              install_java          =>  true,
              install_license       =>  true,
              version               => '4.5.2',
              xld_community_edition => true,
              custom_license_source => 'https://download.xebialabs.com/files/aaf2bef2-b41e-4dc2-aa57-9e51fe72fe27/deployit-license.lic',
              http_server_address   => $::hostname
            }
    }
    EOS

    #apply_manifest(pp, :catch_failures => true)

    apply_manifest(pp, :catch_failures => true)
    expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero

    describe port(4516) do
      it { should be_listening }
    end

    describe user(xldeploy) do
      it {should exist}
    end

    describe file('/opt/xl-deploy/xl-deploy-4.5.2-server') do
      it {should be_directory}
    end

  end



end