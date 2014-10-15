require 'spec_helper'

describe 'xldeploy::server::config' do
  let(:facts) { {:osfamily => 'RedHat',
                   :concat_basedir => '/var/tmp'} }

  context "with xldeploy_default_settings containing valid settings" do
    let (:params) { {
        :version => '4.0.1',
        :base_dir => '/opt/xl-deploy',
        :server_home_dir => "/opt/xl-deploy/xl-deploy-4.0.1-server",
        :cli_home_dir => "/opt/xl-deploy/xl-deploy-4.0.1-cli",
        :os_user => 'xldeploy',
        :os_group => 'xldeploy',
        :ssl => false,
        :http_bind_address => '192.168.0.1',
        :http_port => '4516',
        :http_context_root => '/xldeploy',
        :admin_password => 'admin',
        :jcr_repository_path => 'repository',
        :importable_packages_path => 'importablePackages',
        :java_home => '/usr/lib/jvm/jre-1.6.0-openjdk.x86_64',
        :rest_url => 'http://localhost:4516/xldeploy',
        :xldeploy_default_settings => {'test.test' => {'value' => 'test'}}
    } }

    it { should contain_xldeploy__resources__defaultsetting('test.test').with({
                                                           :value => 'test',
                                                           :key => 'test.test',
                                                           :ensure => 'present'
                                                       }) }
  end

end

