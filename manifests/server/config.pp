# Class deployit::config
#
# This class handles the configuration of the deployit server
class xldeploy::server::config (
  $version                           = $xldeploy::server::version,
  $base_dir                          = $xldeploy::server::base_dir,
  $server_home_dir                   = $xldeploy::server::server_home_dir,
  $cli_home_dir                      = $xldeploy::server::cli_home_dir,
  $os_user                           = $xldeploy::server::os_user,
  $os_group                          = $xldeploy::server::os_group,
  $ssl                               = $xldeploy::server::ssl,
  $http_bind_address                 = $xldeploy::server::http_bind_address,
  $http_port                         = $xldeploy::server::http_port,
  $http_context_root                 = $xldeploy::server::http_context_root,
  $admin_password                    = $xldeploy::server::admin_password,
  $jcr_repository_path               = $xldeploy::server::jcr_repository_path,
  $importable_packages_path          = $xldeploy::server::importable_packages_path,
  $java_home                         = $xldeploy::server::java_home,
  $rest_url                          = $xldeploy::server::rest_url,
  $xldeploy_default_settings         = $xldeploy::server::xldeploy_default_settings,
  $xldeploy_init_repo                = $xldeploy::server::xldeploy_init_repo,
) {


  # Dependencies
  File["${server_home_dir}/conf/deployit.conf", 'xldeploy server plugins', 'xldeploy server ext', 'xldeploy server hotfix', 'xldeploy default properties'
    ]
  -> xldeploy_setup["default"]
  -> Ini_setting['xldeploy.http.port', 'xldeploy.jcr.repository.path', 'xldeploy.ssl', 'xldeploy.http.bind.address', 'xldeploy.http.context.root', 'xldeploy.importable.packages.path', 'xldeploy.admin.password'
    ]
   #-> Exec['init xldeploy']

  # Resource defaults
  File {
    owner  => $os_user,
    group  => $os_group,
    ensure => present,
    mode   => '0640',
    ignore => '.gitkeep'
  }

  Ini_setting {
    path    => "${server_home_dir}/conf/deployit.conf",
    ensure  => present,
    section => '',
  }

  # Resources
  file { "${server_home_dir}/conf/deployit.conf": }



  file { 'xldeploy server plugins':
    ensure       => present,
    source       => [
      'puppet:///modules/xldeploy/plugins/generic',
      'puppet:///modules/xldeploy/plugins/customer',
      "${server_home_dir}/available-plugins"],
    sourceselect => 'all',
    recurse      => true,
    path         => "${server_home_dir}/plugins",
  }

  file { 'xldeploy server hotfix':
    source  => 'puppet:///modules/xldeploy/hotfix/',
    recurse => true,
    purge   => true,
    path    => "${server_home_dir}/hotfix",
  }

  file { 'xldeploy server ext':
    source  => 'puppet:///modules/xldeploy/server-ext/',
    recurse => 'remote',
    path    => "${server_home_dir}/ext",
  }



  file { 'xldeploy default properties':
    ensure => present,
    path   => "${server_home_dir}/conf/deployit-defaults.properties",
  }

  #setup
  xldeploy_setup{'default':
    homedir           => $server_home_dir,
    ssl               => $ssl,
    repository_loc    => regsubst($jcr_repository_path, '^/', 'file:///'),
    packages_loc      => $importable_packages_path,
    http_bind_address => $http_bind_address,
    http_context_root => $http_context_root,
    http_port         => $http_port,
    admin_password    => $admin_password
  }

  # ini settings
  ini_setting {
    'xldeploy.admin.password':
      setting => 'admin.password',
      value   => to_xldeploy_md5($admin_password, $rest_url);

    'xldeploy.http.port':
      setting => 'http.port',
      value   => $http_port;

    'xldeploy.jcr.repository.path':
      setting => 'jcr.repository.path',
      value   => regsubst($jcr_repository_path, '^/', 'file:///');

    'xldeploy.ssl':
      setting => 'ssl',
      value   => $ssl;

    'xldeploy.http.bind.address':
      setting => 'http.bind.address',
      value   => $http_bind_address;

    'xldeploy.http.context.root':
      setting => 'http.context.root',
      value   => $http_context_root;

    'xldeploy.importable.packages.path':
      setting => 'importable.packages.path',
      value   => $importable_packages_path;
  }

#  if str2bool($xldeploy_init_repo) {
#    exec { 'init xldeploy':
#      creates     => "${server_home_dir}/${jcr_repository_path}",
#      command     => "${server_home_dir}/bin/server.sh -setup -reinitialize -force -setup-defaults ${server_home_dir}/conf/deployit.conf",
#      user        => $os_user,
#      environment => ["JAVA_HOME=${java_home}"]
#    }
#  } else {
#    exec { 'init xldeploy':
#      creates     => "${server_home_dir}/${jcr_repository_path}",
#      command     => "${server_home_dir}/bin/server.sh -setup -force -setup-defaults ${server_home_dir}/conf/deployit.conf",
#      user        => $os_user,
#      environment => ["JAVA_HOME=${java_home}"]
#    }
#  }

  create_resources('xldeploy::resources::defaultsetting', $xldeploy_default_settings)

}

