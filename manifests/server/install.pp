# Class xldeploy::server::install
#
# Install the xldeploy server
class xldeploy::server::install (
  $version                     = $xldeploy::server::version,
  $base_dir                    = $xldeploy::server::base_dir,
  $tmp_dir                     = $xldeploy::server::tmp_dir,
  $os_user                     = $xldeploy::server::os_user,
  $os_group                    = $xldeploy::server::os_group,
  $install_type                = $xldeploy::server::install_type,
  $server_home_dir             = $xldeploy::server::server_home_dir,
  $cli_home_dir                = $xldeploy::server::cli_home_dir,
  $install_java                = $xldeploy::server::install_java,
  $java_home                   = $xldeploy::server::java_home,
  $puppetfiles_xldeploy_source = $xldeploy::server::puppetfiles_xldeploy_source,
  $download_user               = $xldeploy::server::download_user,
  $download_password           = $xldeploy::server::download_password,
  $download_proxy_url          = $xldeploy::server::download_proxy_url,
  $download_server_url         = $xldeploy::server::download_server_url,
  $download_cli_url            = $xldeploy::server::download_cli_url,
  $install_license             = $xldeploy::server::install_license,
  $license_source              = $xldeploy::server::license_source,
  $productname                 = $xldeploy::server::productname,
  $server_plugins              = $xldeploy::server::server_plugins
) {

  # Variables

    $server_dir = "${base_dir}/${productname}-${version}-server"
    $cli_dir    = "${base_dir}/${productname}-${version}-cli"


  # Dependencies
  Group[$os_group]
    -> User[$os_user]
    -> File["/var/log/${productname}"]
    -> File["/etc/${productname}"]
    -> File["/etc/init.d/${productname}"]
    -> File[$server_home_dir]
    -> File[$cli_home_dir]
    -> File["${server_home_dir}/scripts"]


  # Resource defaults
  File {
    owner  => $os_user,
    group  => $os_group,
    ensure => present
  }

  # Resources
  case $::osfamily {
    'RedHat' : {
      #TODO: build a better solution for this
      $xtra_packages = ['']
      #User[$os_user] -> Package[$xtra_packages] -> File["/var/log/${productname}"]

      #package { $xtra_packages: ensure => present }
    }
    default  : {
      fail("${::osfamily}:${::operatingsystem} not supported by this module")
    }
  }

  if str2bool($install_java) {
    case $::osfamily {
      'RedHat' : {
        $java_packages = ['java-1.7.0-openjdk']
        User[$os_user] -> Package[$java_packages] -> File["/var/log/${productname}"]

        package { $java_packages: ensure => present }
      }
      default  : {
        fail("${::osfamily}:${::operatingsystem} not supported by this module")
      }
    }
  }

  # user and group

  group { $os_group: ensure => 'present' }

  user { $os_user:
    ensure     => present,
    gid        => $os_group,
    managehome => false,
    home       => $server_home_dir
  }

  # check to see if where on a redhatty system and shut iptables down quicker than you can say wtf
  if !defined(Service[iptables]) {
    case $::osfamily {
      'RedHat' : {
        service { 'iptables': ensure => stopped }
        Service['iptables'] -> File["/etc/${productname}", "/var/log/${productname}"]
      }
      default  : {
      }
    }
  }

  # check the install_type and act accordingly
  case $install_type {
    'puppetfiles' : {
      $server_zipfile = "${productname}-${version}-server.zip"
      $cli_zipfile    = "${productname}-${version}-cli.zip"

      file { "${tmp_dir}/${server_zipfile}": source => "puppet:///${puppetfiles_xldeploy_source}/${server_zipfile}" }

      file { "${tmp_dir}/${cli_zipfile}": source => "puppet:///${puppetfiles_xldeploy_source}/${cli_zipfile}" }

      file { $base_dir: ensure => directory }

      file { $server_dir: ensure => directory }

      file { $cli_dir: ensure => directory }

      exec { 'unpack server file':
        command => "/usr/bin/unzip ${tmp_dir}/${server_zipfile};/bin/cp -rp ${tmp_dir}/${productname}-${version}-server/* ${server_dir}",
        creates => "${server_dir}/bin",
        cwd     => $tmp_dir,
        user    => $os_user
      }

      # ... and cli packages
      exec { 'unpack cli file':
        command => "/usr/bin/unzip ${tmp_dir}/${cli_zipfile};/bin/cp -rp ${tmp_dir}/${productname}-${version}-cli/* ${cli_dir}",
        creates => "${cli_dir}/bin",
        cwd     => $tmp_dir,
        user    => $os_user
      }

      File[$base_dir] -> File[$cli_dir, $server_dir] -> File["${tmp_dir}/${server_zipfile}", "${tmp_dir}/${cli_zipfile}"
        ] -> Exec['unpack server file', 'unpack cli file'] -> File["/etc/${productname}", "/var/log/${productname}"]
    }
    'download'    : {

      file { $base_dir: ensure => directory } ->

      xldeploy_netinstall{$download_server_url:
        owner           => $os_user,
        group           => $os_group,
        user            => $download_user,
        password        => $download_password,
        destinationdir  => $base_dir,
        proxy_url       => $download_proxy_url
      } ->

      xldeploy_netinstall{$download_cli_url:
        owner           => $os_user,
        group           => $os_group,
        user            => $download_user,
        password        => $download_password,
        destinationdir  => $base_dir,
        proxy_url       => $download_proxy_url
      }
      -> File["/etc/${productname}", "/var/log/${productname}"]
    }
    default       : {
    }
  }

  # convenience links


  file { "/var/log/${productname}":
    ensure => link,
    target => "${server_dir}/log";
  }

  file { "/etc/${productname}":
    ensure => link,
    target => "${server_dir}/conf"
  }

  # put the init script in place
  # the template uses the following variables:
  # @os_user
  # @server_dir
  file { "/etc/init.d/${productname}":
    content => template('xldeploy/xldeploy.initd.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0700'
  }

  # setup homedir
  file { $server_home_dir:
    ensure => link,
    target => $server_dir,
    owner  => $os_user,
    group  => $os_group
  }

  file { $cli_home_dir:
    ensure => link,
    target => $cli_dir,
    owner  => $os_user,
    group  => $os_group
  }

  file { "${server_home_dir}/scripts":
    ensure => directory,
    owner  => $os_user,
    group  => $os_group
  }


  if str2bool($install_license) {
    case $license_source {
      /^https/ : { xldeploy_license_install{$license_source:
                      owner                => $os_user,
                      group                => $os_group,
                      user                 => $download_user,
                      password             => $download_password,
                      destinationdirectory => "${server_home_dir}/conf"
                    }
                }
      default : { file{"${server_home_dir}/conf/deployit-license.lic":
                      owner           => $os_user,
                      group           => $os_group,
                      source          => $license_source,
                    }
                }
    }
  }

  $xldeploy_plugin_netinstall_defaults = {
    owner           => $os_user,
    group           => $os_group,
    user            => $download_user,
    password        => $download_password,
    proxy_url       => $download_proxy_url
  }

  create_resources( xldeploy_plugin_netinstall, $server_plugins, $xldeploy_plugin_netinstall_defaults )


}
