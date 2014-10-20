require 'spec_helper_acceptance'
require 'pry'

describe 'server:', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do


  it 'test loading class with no parameters' do
    pp = <<-EOS.unindent
    node default {
      class { 'xldeploy::server':
              install_java      =>  true,
              install_license   =>  true,
              version           => '4.5.0',
              download_user     => 'download',
              download_password => '3BcWgPuvtW3gCu',
              http_server_address => $::hostname
            }
    }
    EOS

    #apply_manifest(pp, :catch_failures => true)
    on master, shell("/bin/cat /'#{pp}/' > /etc/puppet/manifests/site.pp")
    on xldeploy, puppet('agent', '-t')

    on xldeploy, port(4516) do
      it { should be_listening }
    end

  end



end