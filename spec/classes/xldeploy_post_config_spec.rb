require 'spec_helper'

describe 'xldeploy::post_config' do

  context 'with default parameters' do
    let(:facts) { {:osfamily => 'RedHat',
                   :concat_basedir => '/var/tmp'} }

    let(:params) { {
        :http_server_address    => '192.168.0.1',
        :http_port              => '4516',
        :rest_url               => 'http://localhost:4516/deployit',
        :use_exported_resources => true,
        :use_exported_keys      => true,
        :cis                    => {},
        :memberships            => {},
        :users                  => {},
        :roles                  => {},
        :dictionary_settings    => {},
    } }

      it {should contain_xldeploy_check_connection('default').with_host('192.168.0.1').with_port('4516')}
  end

  context 'with cis specified' do
    let(:facts) { {:osfamily => 'RedHat',
                   :concat_basedir => '/var/tmp'} }

    let(:params) { {
        :http_server_address    => '192.168.0.1',
        :http_port              => '4516',
        :rest_url               => 'http://localhost:4516/deployit',
        :use_exported_resources => true,
        :use_exported_keys      => true,
        :cis                    => {'Environments/ZMM' => {
                                      'name' => 'Environments/ZMM',
                                      'type' => 'core.Directory'}},
        :memberships            => {},
        :users                  => {},
        :roles                  => {},
        :dictionary_settings    => {},
    } }

    it {should contain_xldeploy_ci('Environments/ZMM').with_type('core.Directory')}
  end

  context 'with memberships specified' do
    let(:facts) { {:osfamily => 'RedHat',
                   :concat_basedir => '/var/tmp'} }

    let(:params) { {
        :http_server_address    => '192.168.0.1',
        :http_port              => '4516',
        :rest_url               => 'http://localhost:4516/deployit',
        :use_exported_resources => true,
        :use_exported_keys      => true,
        :cis                    => {},
        :memberships            => {'basic memberships jetty' => {
                                      'env' => 'Environments/Test1',
                                      'members' => ['Infrastructure/test1','Infrastructure/test2']
                                   }},
        :users                  => {},
        :roles                  => {},
        :dictionary_settings    => {},
    } }

    it {should contain_xldeploy_environment_member('basic memberships jetty').with({
        :env => 'Environments/Test1',
        :members => ['Infrastructure/test1','Infrastructure/test2'],
        }) }
  end
  context 'with users specified' do
    let(:facts) { {:osfamily => 'RedHat',
                   :concat_basedir => '/var/tmp'} }

    let(:params) { {
        :http_server_address    => '192.168.0.1',
        :http_port              => '4516',
        :rest_url               => 'http://localhost:4516/deployit',
        :use_exported_resources => true,
        :use_exported_keys      => true,
        :cis                    => {},
        :memberships            => {},
        :users                  => { 'basic jetty user' => {
                                      'id'       => 'jenkins',
                                      'password' => 'jenkins1234'
                                   }},
        :roles                  => {},
        :dictionary_settings    => {},
    } }

    it {should contain_xldeploy_user('basic jetty user').with({
           :id       => 'jenkins',
           :password => 'jenkins1234',
       }) }
  end

  context 'with roles specified' do
    let(:facts) { {:osfamily => 'RedHat',
                   :concat_basedir => '/var/tmp'} }

    let(:params) { {
        :http_server_address    => '192.168.0.1',
        :http_port              => '4516',
        :rest_url               => 'http://localhost:4516/deployit',
        :use_exported_resources => true,
        :use_exported_keys      => true,
        :cis                    => {},
        :memberships            => {},
        :users                  => {},
        :roles                  => {'environment_role' => {
                                      'id' => 'jetty',
                                      'users' => ['jenkins','test']
                                   }},
        :dictionary_settings    => {},
    } }

    it {should contain_xldeploy_role('environment_role').with({
                                     :id       => 'jetty',
                                     :users    => ['jenkins', 'test']
                                            }) }
  end

end

