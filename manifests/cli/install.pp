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
  $productname                 = $xldeploy::cli::productname

){

  # Refactor .. stuff getting out of hand

  # Variables

  $cli_install_dir      = "${base_dir}/${productname}-${version}-cli"

  # Flow controll
  anchor{'install':}
  -> anchor{'postinstall':}
  -> File[$cli_home_dir]
  -> anchor{'installend':}


  # Resource defaults
  File {
    owner  => $os_user,
    group  => $os_group,
    ensure => present
  }

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

  file { $cli_home_dir:
    ensure => link,
    target => $cli_install_dir,
    owner  => $os_user,
    group  => $os_group
  }


}
