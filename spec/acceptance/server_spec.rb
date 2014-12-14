require 'spec_helper_acceptance'
require 'pry'

describe 'server:', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do


  it 'test loading class with no parameters' do
    pp = <<-EOS.unindent
    node default {
      class { 'xldeploy::server':
              install_java          =>  true,
              install_license       =>  true,
              version               => '4.5.0',
              #download_user        => 'download',
              #download_password    => '3BcWgPuvtW3gCu',
              xld_community_edition => true,
              custom_license_source => 'https://download.xebialabs.com/files/aaf2bef2-b41e-4dc2-aa57-9e51fe72fe27/deployit-license.lic',
              http_server_address => $::hostname
            }
    }
    EOS

    #apply_manifest(pp, :catch_failures => true)
    on master, shell("/bin/mkdir -p /etc/puppet/manifests")
    on master, shell("/bin/ls /etc/puppet")
    on master, shell("/bin/echo /'#{pp}/' > /etc/puppet/manifests/site.pp")

    run_agent_on(xldeploy, :catch_failures => true)

    on xldeploy, port(4516) do
      it { should be_listening }
    end

  end



end