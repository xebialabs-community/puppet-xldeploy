# = = Class: xldeploy::cli
#
# This class installs xldeploy
#
# === Examples
#
#  class { 'xldeploy::cli':
#  }
#
#
# === Copyright
#
# Copyright (c) 2013, Xebia Nederland b.v., All rights reserved.
#
class xldeploy::cli (
$version                           = $xldeploy::params::version,
$xldeploy_base_dir                 = $xldeploy::params::xldeploy_base_dir,
$tmp_dir                           = $xldeploy::params::tmp_dir,
$os_user                           = $xldeploy::params::os_user,
$os_group                          = $xldeploy::params::os_group,
$install_type                      = $xldeploy::params::install_type,
$puppetfiles_xldeploy_source       = $xldeploy::params::puppetfiles_xldeploy_source,
$download_user                     = $xldeploy::params::download_user,
$download_password                 = $xldeploy::params::download_password,
$download_proxy_url                = $xldeploy::params::download_proxy_url,
$java_home                         = $xldeploy::params::java_home,
$install_java                      = $xldeploy::params::install_java,
$custom_productname                = undef,
$custom_download_server_url        = undef,
$custom_download_cli_url           = undef,
) inherits xldeploy::params {

# this class is not compatible with the xldeploy::server class so let's check for that
if defined(Class['xldeploy::server']){fail('using xldeploy::cli in conjunction with xldeploy::server is not supported')}

# composed variables

#we need to support the two different download urls for xldeploy and deployit
  if ($custom_download_cli_url == undef) {
    if versioncmp($version , '3.9.90') > 0 {
      $download_cli_url    = "https://tech.xebialabs.com/download/xl-deploy/${version}/xl-deploy-${version}-cli.zip"
    } else {
      $download_cli_url    = "https://tech.xebialabs.com/download/deployit/${version}/deployit-${version}-cli.zip"
    }
  } else {
    $download_cli_url    = $custom_download_cli_url
  }

# we need to support two different productnames
  if ($custom_productname == undef) {
    if versioncmp($version , '3.9.90') > 0 {
      $productname         = 'xl-deploy'
    } else {
      $productname         = 'deployit'
    }
  } else {
      $productname = $custom_productname
  }

$base_dir            = "${xldeploy_base_dir}/${productname}"
$cli_home_dir        = "${base_dir}/${productname}-cli"



anchor    { 'xldeploy::cli::begin': }
-> Class  [ 'xldeploy::shared_prereq']
-> class  { 'xldeploy::cli::install': }
-> anchor { 'xldeploy::cli::end': }

  #class to setup shared stuff between cli and server installations
  class{'xldeploy::shared_prereq':
    base_dir => $base_dir,
    os_user => $os_user,
    os_group => $os_group,
    os_user_home => $cli_home_dir,
    install_java => $install_java,
    java_home => $java_home
  }

}
