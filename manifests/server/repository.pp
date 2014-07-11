# class xldeploy::server::repository
# this class takes care of the repository setup
# for now you can either choose standalone of database
# database mode supports postgresql only .... for now ..
class xldeploy::server::repository(
  $os_user                           = $xldeploy::server::os_user,
  $os_group                          = $xldeploy::server::os_group,
  $server_home_dir                   = $xldeploy::server::server_home_dir,
  $repository_type                   = $xldeploy::server::repository_type,
  $datastore_driver                  = $xldeploy::server::datastore_driver,
  $datastore_url                     = $xldeploy::server::datastore_url,
  $datastore_user                    = $xldeploy::server::datastore_user,
  $datastore_password                = $xldeploy::server::datastore_password,
  $datastore_databasetype            = $xldeploy::server::datastore_databasetype,
  $datastore_schema                  = $xldeploy::server::datastore_schema,
  $datastore_persistencemanagerclass = $xldeploy::server::datastore_persistencemanagerclass
){
  # Resource defaults
  File {
    owner  => $os_user,
    group  => $os_group,
    ensure => present,
    mode   => '0640',
    ignore => '.gitkeep'
  }

  if $repository_type == 'standalone' {
    file { "${server_home_dir}/conf/jackrabbit-repository.xml":
      content => template('xldeploy/repository/jackrabbit-repository-standalone.xml.erb')
  }
  } else {
    file { "${server_home_dir}/conf/jackrabbit-repository.xml":
      content => template('xldeploy/repository/jackrabbit-repository-database.xml.erb')
  }
  }
}
