# class xldeploy::repository
# this class takes care of the repository setup
# for now you can either choose standalone of database
# database mode supports postgresql only .... for now ..
class xldeploy::repository(
  $os_user                           = $xldeploy::os_user,
  $os_group                          = $xldeploy::os_group,
  $server_home_dir                   = $xldeploy::server_home_dir,
  $repository_type                   = $xldeploy::repository_type,
  $datastore_driver                  = $xldeploy::datastore_driver,
  $datastore_url                     = $xldeploy::datastore_url,
  $datastore_user                    = $xldeploy::datastore_user,
  $datastore_password                = $xldeploy::datastore_password,
  $datastore_databasetype            = $xldeploy::datastore_databasetype,
  $datastore_schema                  = $xldeploy::datastore_schema,
  $datastore_persistencemanagerclass = $xldeploy::datastore_persistencemanagerclass
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
