# class xldeploy::server::repository
# this class takes care of the repository setup
# for now you can either choose standalone of database
# database mode supports postgresql only .... for now ..
class xldeploy::server::repository(
  $os_user                           = $xldeploy::server::os_user,
  $os_group                          = $xldeploy::server::os_group,
  $server_home_dir                   = $xldeploy::server::server_home_dir,
  $repository_type                   = $xldeploy::server::repository_type,
  $datastore_jdbc_driver_url         = $xldeploy::server::datastore_jdbc_driver_url,
  $datastore_url                     = $xldeploy::server::datastore_url,
  $datastore_user                    = $xldeploy::server::datastore_user,
  $datastore_password                = $xldeploy::server::datastore_password,
  $datastore_databasetype            = $xldeploy::server::datastore_databasetype,
  $download_proxy_url                = $xldeploy::server::download_proxy_url,
  $xldeploy_cluster_id               = $xldeploy::server::xldeploy_cluster_id,
  $jcr_repository_path               = $xldeploy::server::jcr_repository_path,
  $use_exported_resources            = $xldeploy::server::use_exported_resources,
  $xldeploy_cluster_leader           = $xldeploy::server::xldeploy_cluster_leader,
  $xldeploy_cluster_nfs_repo_share   = $xldeploy::server::xldeploy_cluster_nfs_repo_share,
  $xldeploy_cluster_role             = $xldeploy::server::xldeploy_cluster_role
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
    case $datastore_jdbc_driver_url {
      /^http/ : {
        xldeploy_repo_driver_netinstall{$datastore_jdbc_driver_url:
          ensure    => present,
          proxy_url => $download_proxy_url,
          lib_dir   => "${server_home_dir}/lib",
          owner     => $os_user,
          group     => $os_group,
        }
      }

      /^puppet/ : {
        $driver_file_name = get_filename($datastore_jdbc_driver_url)
        file{"${server_home_dir}/lib/${driver_file_name}":
          ensure => present,
          source => $datastore_jdbc_driver_url,
          owner  => $os_user,
          group  => $os_group,
        }
      }
      default : {}
    }
    if $xldeploy_cluster_id == undef {
      case $datastore_databasetype {
        /postgres/ : {
          file { "${server_home_dir}/conf/jackrabbit-repository.xml":
            content => template('xldeploy/repository/jackrabbit-repository-db-postgresql.xml.erb')
          }
        }
        /mysql/ : {
          file { "${server_home_dir}/conf/jackrabbit-repository.xml":
            content => template('xldeploy/repository/jackrabbit-repository-db-mysql.xml.erb')
          }
        }
        default : { fail "${datastore_databasetyp} not supported" }
        }
      } else {
      case $datastore_databasetype {
        /postgres/ : {
          file { "${server_home_dir}/conf/jackrabbit-repository.xml":
            content => template('xldeploy/repository/jackrabbit-repository-db-postgresql-cluster.xml.erb')
          }
        }
        /mysql/ : {
          file { "${server_home_dir}/conf/jackrabbit-repository.xml":
            content => template('xldeploy/repository/jackrabbit-repository-db-mysql-cluster.xml.erb')
          }
        }
        default : { fail "${datastore_databasetyp} not supported" }
        }
      }
    }

    if $xldeploy_cluster_id != undef {
      case $xldeploy_cluster_role {
        'master' : {
          class { 'nfs::server':}
          nfs::server::export{ "${server_home_dir}/${jcr_repository_path}":
            ensure  => 'mounted',
            bind    => 'rbind',
            mount     => undef,
            remounts  => false,
            atboot    => true,
            options   => '_netdev',
            bindmount => undef,
            nfstag     => undef,
            clients => '10.0.0.0/24(rw,insecure,no_subtree_check,async,no_root_squash)'
          }
        }
        'slave'  : {
        if $use_exported_resources == true {
          include '::nfs::client'
          Nfs::Client::Mount <<| |>>{
            atboot    => true
          }
        } else {
          define nfs::client::mount (
            server => $xldeploy_cluster_leader,
            share  => $xldeploy_cluster_nfs_repo
          }
        }
        default  : {fail 'cluster role should be set'}
      }
    }
  }


