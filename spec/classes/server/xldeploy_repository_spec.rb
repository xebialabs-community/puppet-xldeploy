require 'spec_helper'

# TODO: check template content ..

describe 'xldeploy::server::repository' do
  let(:facts) { {:osfamily       => 'RedHat',
                 :concat_basedir => '/var/tmp'} }
  context 'with repository_type set to standalone' do


    let(:params) { {
        :os_user         => 'xldeploy',
        :os_group        => 'xldeploy',
        :server_home_dir => '/opt/xldeploy/xldeploy-server',
        :repository_type => 'standalone'
    }}

    it { should contain_file('/opt/xldeploy/xldeploy-server/conf/jackrabbit-repository.xml').with({
        :ensure => 'present',
        :owner  => 'xldeploy',
        :group  => 'xldeploy',
        :mode   => '0640'
     }) }

    end
 
  context 'with repository set to standalone' do

    let(:params) { {  :repository_type          => 'standalone',
                      :os_group                 => 'xl-deploy',
                      :server_home_dir          => '/opt/xldeploy/xldeploy-server',
                      :os_user                  => 'xl-deploy'
    } }

    it { should contain_file('/opt/xldeploy/xldeploy-server/conf/jackrabbit-repository.xml')}
    it { should_not contain_xldeploy_repo_driver_netinstall('http://some.driver.url/some_driver.jar')}


  end




end
