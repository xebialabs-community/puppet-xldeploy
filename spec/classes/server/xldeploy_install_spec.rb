require 'spec_helper'

describe 'xldeploy::server::install' do


  shared_examples '3.9.x on a Linux Os' do
    let :default_params do
      {
          :version                     => '3.9.4',
          :tmp_dir                     => '/var/tmp',
          :base_dir                    => '/opt/deployit',
          :os_user                     => 'deployit',
          :os_group                    => 'deployit',
          :download_user               => 'download',
          :download_password           => 'download',
          :server_home_dir             => '/opt/deployit/deployit-server',
          :download_server_url         => 'https://tech.xebialabs.com/download/deployit/3.9.4/deployit-3.9.4-server.zip',
          :productname                 => 'deployit',
          :server_plugins              => { }
      }
    end

    context 'with dowload_source set to a puppeturl' do
      let :params do
          default_params.merge({
                  :download_server_url => 'puppet:///modules/xldeploy/xldeploy.zip'
                   })
      end

      it {should contain_file('/var/tmp/deployit-3.9.4-server.zip').with_source('puppet:///modules/xldeploy/xldeploy.zip')}
      it {should contain_file('/opt/deployit/deployit-server').with_ensure('link')}
      it {should contain_exec('unpack server file').with({
                      :command => '/usr/bin/unzip -o /var/tmp/deployit-3.9.4-server.zip;/bin/cp -rp /var/tmp/deployit-3.9.4-server/* /opt/deployit/deployit-3.9.4-server',
                      :creates => '/opt/deployit/deployit-3.9.4-server/bin',
                      :cwd     => '/var/tmp',
                      :user    => 'deployit'
              }) }
    end

    context 'with community edition dowload_source set to a puppeturl' do
      let :params do
          default_params.merge({
                  :download_server_url => 'puppet:///modules/xldeploy/xldeploy-free-edition.zip',
                  :xld_community_edition => true
                   })
      end

      it {should contain_file('/var/tmp/deployit-3.9.4-server-free-edition.zip').with_source('puppet:///modules/xldeploy/xldeploy-free-edition.zip')}
      it {should contain_file('/opt/deployit/deployit-server').with_ensure('link')}
      it {should contain_exec('unpack server file').with({
                      :command => '/usr/bin/unzip -o /var/tmp/deployit-3.9.4-server-free-edition.zip;/bin/cp -rp /var/tmp/deployit-3.9.4-server-free-edition/* /opt/deployit/deployit-3.9.4-server-free-edition',
                      :creates => '/opt/deployit/deployit-3.9.4-server-free-edition/bin',
                      :cwd     => '/var/tmp',
                      :user    => 'deployit'
              }) }
    end

  end

  shared_examples '4.x.x on a Linux Os' do
    let :default_params do
      {
          :version                     => '4.5.0',
          :tmp_dir                     => '/var/tmp',
          :base_dir                    => '/opt/xldeploy',
          :os_user                     => 'deployit',
          :os_group                    => 'deployit',
          :download_user               => 'download',
          :download_password           => 'download',
          :server_home_dir             => '/opt/xldeploy/xldeploy-server',
          :download_server_url         => 'https://tech.xebialabs.com/download/xl-deploy/4.5.0/xl-deploy-4.5.0-server.zip',
          :productname                 => 'xldeploy',
          :server_plugins              => { }
      }
    end

    context 'with dowload_source set to a puppeturl' do
      let :params do
          default_params.merge({
                          :download_server_url => 'puppet:///modules/xldeploy/xldeploy.zip'
                               })
      end

      it {should contain_file('/var/tmp/xldeploy-4.5.0-server.zip').with_source('puppet:///modules/xldeploy/xldeploy.zip')}
      it {should contain_file('/opt/xldeploy/xldeploy-server').with_ensure('link')}
      it {should contain_exec('unpack server file').with({
                      :command => '/usr/bin/unzip -o /var/tmp/xldeploy-4.5.0-server.zip;/bin/cp -rp /var/tmp/xldeploy-4.5.0-server/* /opt/xldeploy/xldeploy-4.5.0-server',
                      :creates => '/opt/xldeploy/xldeploy-4.5.0-server/bin',
                      :cwd     => '/var/tmp',
                      :user    => 'deployit'
              }) }
    end

    context 'with community edition dowload_source set to a puppeturl' do
      let :params do
          default_params.merge({
                          :download_server_url => 'puppet:///modules/xldeploy/xldeploy-free-edition.zip',
                          :xld_community_edition => true
                               })
      end

      it {should contain_file('/var/tmp/xldeploy-4.5.0-server-free-edition.zip').with_source('puppet:///modules/xldeploy/xldeploy-free-edition.zip')}
      it {should contain_file('/opt/xldeploy/xldeploy-server').with_ensure('link')}
      it {should contain_exec('unpack server file').with({
                      :command => '/usr/bin/unzip -o /var/tmp/xldeploy-4.5.0-server-free-edition.zip;/bin/cp -rp /var/tmp/xldeploy-4.5.0-server-free-edition/* /opt/xldeploy/xldeploy-4.5.0-server-free-edition',
                      :creates => '/opt/xldeploy/xldeploy-4.5.0-server-free-edition/bin',
                      :cwd     => '/var/tmp',
                      :user    => 'deployit'
              }) }
    end

    context 'with install_license set to true and puppet file given' do
      let :params do
        default_params.merge({
                                 :install_license             => 'true',
                                 :license_source              => 'modules/xldeploy/file/deployit-license.lic',
                             })
      end
      it {should contain_file('/opt/xldeploy/xldeploy-server/conf/deployit-license.lic').with_source('modules/xldeploy/file/deployit-license.lic')}
    end

    context 'with install_license set to true and url given' do
      let :params do
        default_params.merge({
                                 :install_license             => 'true',
                                 :license_source              => 'https://tech.xebialabs.com/download/licenses/download/deployit-license.lic',
                             })
      end

      it {should contain_xldeploy_license_install('https://tech.xebialabs.com/download/licenses/download/deployit-license.lic').with_destinationdirectory('/opt/xldeploy/xldeploy-server/conf')}
    end
  end
  
  
  context "Debian OS" do
    let :facts do
      {
          :operatingsystem => 'Debian',
          :osfamily        => 'Debian',
          :lsbdistcodename => 'precise',
          :lsbdistid       => 'Debian',
          :concat_basedir  => '/var/tmp'
      }
    end
    it_behaves_like "3.9.x on a Linux Os" do

    end
    it_behaves_like "4.x.x on a Linux Os" do

    end

  end

  context "RedHat OS with xldeploy 3.9.x" do
    let :facts do
      {
          :operatingsystem => 'RedHat',
          :osfamily        => 'RedHat',
          :concat_basedir  => '/var/tmp'
      }
    end
    it_behaves_like "3.9.x on a Linux Os" do

    end
    it_behaves_like "4.x.x on a Linux Os" do

    end
  end


end


