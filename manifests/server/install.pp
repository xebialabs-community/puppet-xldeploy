# Class xldeploy::server::install
#
# Install the xldeploy server
class xldeploy::server::install (
  $version                     = $xldeploy::server::version,
  $base_dir                    = $xldeploy::server::base_dir,
  $tmp_dir                     = $xldeploy::server::tmp_dir,
  $os_user                     = $xldeploy::server::os_user,
  $os_group                    = $xldeploy::server::os_group,
  #$install_type                = $xldeploy::server::install_type,
  $server_home_dir             = $xldeploy::server::server_home_dir,
  #$puppetfiles_xldeploy_source = $xldeploy::server::puppetfiles_xldeploy_source,
  $download_user               = $xldeploy::server::download_user,
  $download_password           = $xldeploy::server::download_password,
  $download_proxy_url          = $xldeploy::server::download_proxy_url,
  $download_server_url         = $xldeploy::server::download_server_url,
  $install_license             = $xldeploy::server::install_license,
  $license_source              = $xldeploy::server::license_source,
  $productname                 = $xldeploy::server::productname,
  $server_plugins              = $xldeploy::server::server_plugins,
  $disable_firewall            = $xldeploy::server::disable_firewall,
  $xld_community_edition       = $xldeploy::server::xld_community_edition
) {

  # Refactor .. stuff getting out of hand

  # Variables
  if str2bool($xld_community_edition) {
    $server_install_dir   = "${base_dir}/${productname}-${version}-server-free-edition"
  } else {
    $server_install_dir   = "${base_dir}/${productname}-${version}-server"
  }
  # Flow controll

  anchor{'server::preinstall':}
  -> anchor{'server::install':}
  -> anchor{'server::postinstall':}
  -> File['conf dir link', 'log dir link']
  -> File[$server_home_dir]
  -> anchor{'server::installend':}


  # Resource defaults
  File {
    owner  => $os_user,
    group  => $os_group,
    ensure => present
  }

  # check to see if where on a redhatty system and shut iptables down quicker than you can say wtf
  # only when disable_firewall is true
  if str2bool($disable_firewall) {
    if !defined(Service[iptables]) {
      case $::osfamily {
        'RedHat' : {
                      service { 'iptables': ensure => stopped }
                      Anchor['server::preinstall'] -> Service['iptables'] -> Anchor['server::install']
                    }
        default  : {
                    }
      }
    }
  }



  case $download_server_url {
    /^http/ : {
        if str2bool($xld_community_edition) == false {
          Xldeploy_netinstall{
            user           => $download_user,
            password       => $download_password,
          }
        }

        Anchor['server::install']


        -> xldeploy_netinstall{$download_server_url:
            owner          => $os_user,
            group          => $os_group,
            destinationdir => $base_dir,
            proxy_url      => $download_proxy_url
          }

        -> Anchor['server::postinstall']

      }
    /^puppet/ : {
        $server_zipfile = "${productname}-${version}-server.zip"

        Anchor['server::install']

        -> file { "${tmp_dir}/${server_zipfile}": source => $download_server_url }

        -> file { $server_install_dir: ensure => directory }

        -> exec { 'unpack server file':
          command => "/usr/bin/unzip ${tmp_dir}/${server_zipfile};/bin/cp -rp ${tmp_dir}/${productname}-${version}-server/* ${server_install_dir}",
          creates => "${server_install_dir}/bin",
          cwd     => $tmp_dir,
          user    => $os_user
        }

        -> Anchor['server::postinstall']
      }
    default : {
        fail 'either specify a valid http or puppetfiles(puppet:) url'
          }
  }


  # convenience links

  file { 'log dir link':
    ensure => link,
    path   => "/var/log/${productname}",
    target => "${server_install_dir}/log";
  }

  file { 'conf dir link':
    ensure => link,
    path   => "/etc/${productname}",
    target => "${server_install_dir}/conf"
  }

  # put the init script in place
  # the template uses the following variables:
  # @os_user
  # @server_install_dir
  if versioncmp($version , '4.9.99') < 0 {
    File[$server_home_dir] ->
    file { "/etc/init.d/${productname}":
      content => template("xldeploy/xldeploy-initd-${::osfamily}.erb"),
      owner   => 'root',
      group   => 'root',
      mode    => '0700'
    }
    -> Anchor['server::installend']
  } else {
    File[$server_home_dir] ->
    exec {"echo ${os_user}|${server_install_dir}/bin/install-service.sh":}
    -> Anchor['server::installend']
  }


  # setup homedir
  file { $server_home_dir:
    ensure => link,
    target => $server_install_dir,
    owner  => $os_user,
    group  => $os_group
  }

  file { "${server_home_dir}/scripts":
    ensure => directory,
    owner  => $os_user,
    group  => $os_group
  }

  if versioncmp($version , '3.9.90') > 0 {
    if str2bool($install_license) {
      case $license_source {
      /^http/ : {
                  if str2bool($xld_community_edition) == false {
                    Xldeploy_license_install{
                      user           => $download_user,
                      password       => $download_password,
                    }
                  }

                  File[$server_home_dir]

                  -> xldeploy_license_install{$license_source:
                      user                 => $download_user,
                      password             => $download_password,
                      owner                => $os_user,
                      group                => $os_group,
                      destinationdirectory => "${server_home_dir}/conf"
                    }
                  -> Anchor['server::installend']
            }
      default : {
                  File[$server_home_dir]

                  -> file{"${server_home_dir}/conf/deployit-license.lic":
                      owner  => $os_user,
                      group  => $os_group,
                      source => $license_source,
                    }
                  -> Anchor['server::installend']
            }
      }
    }
  }


  $xldeploy_plugin_netinstall_defaults = {
    owner           => $os_user,
    group           => $os_group,
    user            => $download_user,
    password        => $download_password,
    proxy_url       => $download_proxy_url,
    plugin_dir      => "${server_home_dir}/plugins",
    require         => Anchor['server::installend']
  }

  create_resources( xldeploy_plugin_netinstall, $server_plugins, $xldeploy_plugin_netinstall_defaults )


}