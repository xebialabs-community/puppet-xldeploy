# Class xldeploy::server::server::install
#
# Install the xldeploy::server::server server
class xldeploy::server::housekeeping (
  $os_user         = $xldeploy::server::os_user,
  $os_group        = $xldeploy::server::os_group,
  $server_home_dir = $xldeploy::server::server_home_dir,
  $cli_home_dir    = $xldeploy::server::cli_home_dir,
  $http_port       = $xldeploy::server::http_port,
  $admin_password  = $xldeploy::server::admin_password) {

  file { "${server_home_dir}/scripts/xldeploy-housekeeping.sh":
    ensure  => present,
    content => template('xldeploy/xldeploy-housekeeping.sh.erb'),
    mode    => '0744',
  }

  file { "${server_home_dir}/scripts/garbage-collector.py": ensure => absent, }

  file { "${server_home_dir}/scripts/housekeeping.py":
    ensure => present,
    source => 'puppet:///modules/xldeploy/scripts/housekeeping.py',
  }

  cron { 'xldeploy-housekeeping':
    ensure  => present,
    command => "${server_home_dir}/scripts/xldeploy-housekeeping.sh",
    user    => root,
    hour    => 2,
    minute  => 5,
  }

}
