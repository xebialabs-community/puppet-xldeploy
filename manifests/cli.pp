# = = Class: xldeploy::cli
#
# This class installs xldeploy cli
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
  $install_type                      = $xldeploy::params::install_type,
  $puppetfiles_xldeploy_source       = $xldeploy::params::puppetfiles_xldeploy_source,
  $download_user                     = $xldeploy::params::download_user,
  $download_password                 = $xldeploy::params::download_password,
  $download_proxy_url                = $xldeploy::params::download_proxy_url,
  $java_home                         = $xldeploy::params::java_home,
  $install_java                      = $xldeploy::params::install_java,
  $xld_community_edition             = $xldeploy::params::xld_community_edition,
  $custom_os_user                    = undef,
  $custom_os_group                   = undef,
  $custom_productname                = undef,
  $custom_download_server_url        = undef,
  $custom_download_cli_url           = undef,
  $custom_license_source             = undef,
) inherits xldeploy::params {


  # composed variables

  #we need to support the two different download urls for xldeploy and deployit
    if ($custom_download_cli_url == undef) {
      if str2bool($xld_community_edition) {
        $download_cli_url    = "https://download.xebialabs.com/files/Generic/xl-deploy-4.5.2-cli-free-edition.zip"
      } else {
        if versioncmp($version , '3.9.90') > 0 {
          $download_cli_url    = "https://tech.xebialabs.com/download/xl-deploy/${version}/xl-deploy-${version}-cli.zip"
        }else {
          $download_cli_url    = "https://tech.xebialabs.com/download/deployit/${version}/deployit-${version}-cli.zip"
        }
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

    if ($custom_os_user == undef) {
      if versioncmp($version , '3.9.90') > 0 {
        $os_user         = 'xldeploy'
      } else {
        $os_user         = 'deployit'
      }
    } else {
      $os_user = $custom_os_user
    }

    if ($custom_os_group == undef) {
      if versioncmp($version , '3.9.90') > 0 {
        $os_group         = 'xldeploy'
      } else {
        $os_group         = 'deployit'
      }
    } else {
      $os_group = $custom_os_group
    }

    if ($custom_license_source == undef) {
      $license_source      = 'https://tech.xebialabs.com/download/licenses/download/deployit-license.lic'
    } else {
      $license_source      = $custom_license_source
    }

  $base_dir            = "${xldeploy_base_dir}/${productname}"
  $cli_home_dir        = "${base_dir}/${productname}-cli"



  anchor    { 'xldeploy::cli::begin':}
  -> class  { 'xldeploy::cli::install':}
  -> anchor { 'xldeploy::cli::end':}

    #class to setup shared stuff between cli and server installations
  if !defined(Class['Xldeploy::Shared_prereq']){
    Anchor['xldeploy::cli::begin']
    -> class{'xldeploy::shared_prereq':
      base_dir     => $base_dir,
      os_user      => $os_user,
      os_group     => $os_group,
      os_user_home => $cli_home_dir,
      install_java => $install_java,
      java_home    => $java_home
    }
    -> Class[ 'xldeploy::cli::install']
  }
}