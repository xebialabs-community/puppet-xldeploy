# Class xldeploy::install
#
# Install the xldeploy server
class xldeploy::housekeeping (
  $os_user         = $xldeploy::os_user,
  $os_group        = $xldeploy::os_group,
  $server_home_dir = $xldeploy::server_home_dir,
  $cli_home_dir    = $xldeploy::cli_home_dir,
  $http_port       = $xldeploy::http_port) {

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
