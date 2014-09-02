# Class xldeploy::server::install
#
# Install the xldeploy server
class xldeploy::cli::install (
  $version                     = $xldeploy::cli::version,
  $base_dir                    = $xldeploy::cli::base_dir,
  $tmp_dir                     = $xldeploy::cli::tmp_dir,
  $os_user                     = $xldeploy::cli::os_user,
  $os_group                    = $xldeploy::cli::os_group,
  $install_type                = $xldeploy::cli::install_type,
  $cli_home_dir                = $xldeploy::cli::cli_home_dir,
  $install_java                = $xldeploy::cli::install_java,
  $java_home                   = $xldeploy::cli::java_home,
  $puppetfiles_xldeploy_source = $xldeploy::cli::puppetfiles_xldeploy_source,
  $download_user               = $xldeploy::cli::download_user,
  $download_password           = $xldeploy::cli::download_password,
  $download_proxy_url          = $xldeploy::cli::download_proxy_url,
  $download_cli_url            = $xldeploy::cli::download_cli_url,
){

  # Refactor .. stuff getting out of hand

  # Variables

  $cli_install_dir      = "${base_dir}/${productname}-${version}-cli"

  # Flow controll
  Group[$os_group]
  -> User[$os_user]
  -> anchor{'userandgroup':}
  -> anchor{'preinstall':}
  -> File[$base_dir]
  -> anchor{'install':}
  -> anchor{'postinstall':}
  -> File[$cli_home_dir]
  -> anchor{'installend':}


  # Resource defaults
  File {
    owner  => $os_user,
    group  => $os_group,
    ensure => present
  }



  # install java packages if needed
  if str2bool($install_java) {
    case $::osfamily {
      'RedHat' : {
        $java_packages = ['java-1.7.0-openjdk']
        package { $java_packages: ensure => present }
        Anchor['preinstall']-> Package[$java_packages] -> Anchor['install']
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

  # base dir

  file { $base_dir: ensure => directory }


  # check the install_type and act accordingly
  case $install_type {
    'puppetfiles' : {

    $cli_zipfile    = "${productname}-${version}-cli.zip"

    Anchor['install']

    -> file { "${tmp_dir}/${cli_zipfile}": source => "${puppetfiles_xldeploy_source}/${cli_zipfile}" }

    -> file { $cli_install_dir: ensure => directory }

    # ... and cli packages
    -> exec { 'unpack cli file':
      command => "/usr/bin/unzip ${tmp_dir}/${cli_zipfile};/bin/cp -rp ${tmp_dir}/${productname}-${version}-cli/* ${cli_install_dir}",
      creates => "${cli_install_dir}/bin",
      cwd     => $tmp_dir,
      user    => $os_user
    }
    -> Anchor['postinstall']
  }
    'download'    : {

      Anchor['install']

      -> xldeploy_netinstall{$download_cli_url:
          owner           => $os_user,
          group           => $os_group,
          user            => $download_user,
          password        => $download_password,
          destinationdir  => $base_dir,
          proxy_url       => $download_proxy_url
         }

      -> Anchor['postinstall']
    }
    default       : {
    }
  }

  # convenience links

  # put the init script in place
  # the template uses the following variables:
  # @os_user
  # @server_install_dir

  file { $cli_home_dir:
    ensure => link,
    target => $cli_install_dir,
    owner  => $os_user,
    group  => $os_group
  }


}
