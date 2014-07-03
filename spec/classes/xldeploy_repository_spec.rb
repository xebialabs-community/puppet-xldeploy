require 'spec_helper'

# TODO: check template content ..

describe 'xldeploy::repository' do
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

end
