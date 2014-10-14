require 'spec_helper'

describe 'xldeploy::server::install' do


  shared_examples 'a Linux Os' do
    context 'with defaults' do
        let(:params) {{ :version                     => '3.9.4',
                        :base_dir                    => '/opt/deployit',
                        :tmp_dir                     => '/var/tmp',
                        :os_user                     => 'deployit',
                        :os_group                    => 'deployit',
                        :install_type                => 'puppetfiles',
                        :server_home_dir             => '/opt/deployit/deployit-server',
                        :puppetfiles_xldeploy_source => 'modules/deployit/sources',
                        :productname                 => 'deployit',
                        :server_plugins              => { }
        }}

        it {should contain_file('log dir link').with_ensure('link').with_target('/opt/deployit/deployit-3.9.4-server/log')}
        it {should contain_file('conf dir link').with_ensure('link').with_target('/opt/deployit/deployit-3.9.4-server/conf')}
        it {should contain_file('/etc/init.d/deployit').with_owner('root').with_group('root').with_mode('0700')}
        it {should contain_file('/opt/deployit/deployit-server').with_owner('deployit').with_group('deployit').with_ensure('link').with_target('/opt/deployit/deployit-3.9.4-server')}
        it {should contain_file('/opt/deployit/deployit-server/scripts').with_owner('deployit').with_group('deployit').with_ensure('directory')}

    end

    context 'with install_type set to puppetfiles' do
      let(:params) {{:version                     => '3.9.4',
                     :base_dir                    => '/opt/deployit',
                     :tmp_dir                     => '/var/tmp',
                     :os_user                     => 'deployit',
                     :os_group                    => 'deployit',
                     :install_type                => 'puppetfiles',
                     :server_home_dir             => '/opt/deployit/deployit-server',
                     :puppetfiles_xldeploy_source => 'modules/deployit/sources',
                     :productname                 => 'deployit',
                     :server_plugins              => { }
      }}

      it {should contain_file('/var/tmp/deployit-3.9.4-server.zip').with_source('modules/deployit/sources/deployit-3.9.4-server.zip')}
      it {should contain_file('/opt/deployit/deployit-server').with_ensure('link')}
      it {should contain_exec('unpack server file').with({
                      :command => '/usr/bin/unzip /var/tmp/deployit-3.9.4-server.zip;/bin/cp -rp /var/tmp/deployit-3.9.4-server/* /opt/deployit/deployit-3.9.4-server',
                      :creates => '/opt/deployit/deployit-3.9.4-server/bin',
                      :cwd     => '/var/tmp',
                      :user    => 'deployit'
              }) }
    end

    context 'with install_type set to downloads' do
      let(:params) {{:version                     => '3.9.4',
                     :base_dir                    => '/opt/deployit',
                     :tmp_dir                     => '/var/tmp',
                     :os_user                     => 'deployit',
                     :os_group                    => 'deployit',
                     :install_type                => 'download',
                     :download_user               => 'download',
                     :download_password           => 'download',
                     :server_home_dir             => '/opt/deployit/deployit-server',
                     :download_server_url         => 'https://tech.xebialabs.com/download/deployit/3.9.4/deployit-3.9.4-server.zip',
                     :puppetfiles_xldeploy_source => 'modules/deployit/sources',
                     :productname                 => 'deployit',
                     :server_plugins              => { }
      }}

      it {should contain_xldeploy_netinstall('https://tech.xebialabs.com/download/deployit/3.9.4/deployit-3.9.4-server.zip')}
    end
    context 'with install_license set to true and puppet file given' do
      let(:params) {{:version                     => '4.0.1',
                     :base_dir                    => '/opt/xldeploy',
                     :tmp_dir                     => '/var/tmp',
                     :os_user                     => 'xldeploy',
                     :os_group                    => 'xldeploy',
                     :install_type                => 'download',
                     :download_user               => 'download',
                     :download_password           => 'download',
                     :server_home_dir             => '/opt/xldeploy/xldeploy-server',
                     :download_server_url         => 'https://tech.xebialabs.com/download/xl-deploy/4.0.1/xl-deploy-4.0.1-server.zip',
                     :puppetfiles_xldeploy_source => 'modules/xldeploy/sources',
                     :install_license             => 'true',
                     :license_source              => 'modules/xldeploy/file/deployit-license.lic',
                     :productname                 => 'deployit',
                     :server_plugins              => { }
      }}

      it {should contain_file('/opt/xldeploy/xldeploy-server/conf/deployit-license.lic').with_source('modules/xldeploy/file/deployit-license.lic')}
    end
    context 'with install_license set to true and url given' do
      let(:params) {{:version                     => '4.0.1',
                     :base_dir                    => '/opt/deployit',
                     :tmp_dir                     => '/var/tmp',
                     :os_user                     => 'deployit',
                     :os_group                    => 'deployit',
                     :install_type                => 'download',
                     :download_user               => 'download',
                     :download_password           => 'download',
                     :server_home_dir             => '/opt/deployit/deployit-server',
                     :download_server_url         => 'https://tech.xebialabs.com/download/deployit/3.9.4/deployit-3.9.4-server.zip',
                     :puppetfiles_xldeploy_source => 'modules/deployit/sources',
                     :install_license             => 'true',
                     :license_source              => 'https://tech.xebialabs.com/download/licenses/download/deployit-license.lic',
                     :productname                 => 'deployit',
                     :server_plugins              => { }
      }}

      it {should contain_xldeploy_license_install('https://tech.xebialabs.com/download/licenses/download/deployit-license.lic').with_destinationdirectory('/opt/deployit/deployit-server/conf')}
    end
    context 'with install_license set to true and url given' do
      let(:params) {{:version                     => '4.0.1',
                     :base_dir                    => '/opt/deployit',
                     :tmp_dir                     => '/var/tmp',
                     :os_user                     => 'deployit',
                     :os_group                    => 'deployit',
                     :install_type                => 'download',
                     :download_user               => 'download',
                     :download_password           => 'download',
                     :server_home_dir             => '/opt/deployit/deployit-server',
                     :download_server_url         => 'https://tech.xebialabs.com/download/deployit/3.9.4/deployit-3.9.4-server.zip',
                     :puppetfiles_xldeploy_source => 'modules/deployit/sources',
                     :install_license             => 'true',
                     :license_source              => 'https://tech.xebialabs.com/download/licenses/download/deployit-license.lic',
                     :productname                 => 'deployit',
                     :server_plugins              => { }
      }}

      it {should contain_xldeploy_license_install('https://tech.xebialabs.com/download/licenses/download/deployit-license.lic').with_destinationdirectory('/opt/deployit/deployit-server/conf')}
    end
  end
  context "Debian OS" do
    it_behaves_like "a Linux Os" do
      let :facts do
        {
            :operatingsystem => 'Debian',
            :osfamily        => 'Debian',
            :lsbdistcodename => 'precise',
            :lsbdistid       => 'Debian',
            :concat_basedir  => '/var/tmp'
        }
      end
    end
  end

  context "RedHat OS" do
    it_behaves_like "a Linux Os" do
      let :facts do
        {
            :operatingsystem => 'RedHat',
            :osfamily        => 'RedHat',
            :concat_basedir  => '/var/tmp'
        }
      end
    end
  end

end


