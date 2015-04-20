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
  context 'with repository_type set to database' do
    let(:params) { {
        :os_user                           => 'xldeploy',
        :os_group                          => 'xldeploy',
        :server_home_dir                   => '/opt/xldeploy/xldeploy-server',
        :repository_type                   => 'database',
        :datastore_driver                  => 'org.postgresql.Driver',
        :datastore_url                     => 'jdbc:postgresql://localhost:5432/xldeploy',
        :datastore_user                    => 'xldeploy',
        :datastore_password                => 'xldeploy',
        :datastore_databasetype            => 'postgresql',
        :datastore_schema                  => 'postgresql',
        :datastore_persistencemanagerclass => 'org.apache.jackrabbit.core.persistence.pool.PostgreSQLPersistenceManager',
    } }
    it { should contain_file('/opt/xldeploy/xldeploy-server/conf/jackrabbit-repository.xml').with({
        :ensure => 'present',
        :owner => 'xldeploy',
        :group => 'xldeploy',
        :mode => '0640'
    }) }
  end

  context 'with datastore_jdbc_driver_url set to a http address and repository_type set to database' do

    let(:params) { {  :repository_type          => 'database',
                      :datastore_jdbc_driver_url => 'http://some.driver.url/some_driver.jar',
                      :server_home_dir          => '/opt/xldeploy/xldeploy-server',
                      :os_group                 => 'xl-deploy',
                      :os_user                  => 'xl-deploy'
    } }

    it { should contain_file('/opt/xldeploy/xldeploy-server/conf/jackrabbit-repository.xml')}
    it { should contain_xldeploy_repo_driver_netinstall('http://some.driver.url/some_driver.jar').with_ensure('present').with_lib_dir('/opt/xldeploy/xldeploy-server/lib').with_owner('xl-deploy')}


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

  context 'with datastore_jdbc_driver_url set to a puppet url and repository_type set to database' do

    let(:params) { {  :repository_type          => 'database',
                      :datastore_jdbc_driver_url => 'puppet:///some.driver.url/some_driver.jar',
                      :server_home_dir          => '/opt/xldeploy/xldeploy-server',
                      :os_group                 => 'xl-deploy',
                      :os_user                  => 'xl-deploy'
    } }

    it { should contain_file('/opt/xldeploy/xldeploy-server/conf/jackrabbit-repository.xml')}
    it { should contain_file('/opt/xldeploy/xldeploy-server/lib/some_driver.jar').with_owner('xl-deploy')}


  end


end
