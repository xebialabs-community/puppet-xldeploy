# = = Class: xldeploy
#
# This class installs xldeploy
#
# === Examples
#
#  class { 'xldeploy':
#  }
#
# === Parameters
# [*import_ssh_key*]
#  on client: import xldeploy public key from puppetdb
#
# === Copyright
#
# Copyright (c) 2013, Xebia Nederland b.v., All rights reserved.
#
class xldeploy::server (
  $version                           = $xldeploy::params::version,
  $xldeploy_base_dir                 = $xldeploy::params::xldeploy_base_dir,
  $xldeploy_init_repo                = $xldeploy::params::xldeploy_init_repo,
  $tmp_dir                           = $xldeploy::params::tmp_dir,
  $import_ssh_key                    = $xldeploy::params::import_ssh_key,
  $http_bind_address                 = $xldeploy::params::http_bind_address,
  $http_port                         = $xldeploy::params::http_port,
  $http_context_root                 = $xldeploy::params::http_context_root,
  $http_server_address               = $xldeploy::params::http_server_address,
  $admin_password                    = $xldeploy::params::admin_password,
  $jcr_repository_path               = $xldeploy::params::jcr_repository_path,
  $importable_packages_path          = $xldeploy::params::importable_packages_path,
  $install_type                      = $xldeploy::params::install_type,
  $puppetfiles_xldeploy_source       = $xldeploy::params::puppetfiles_xldeploy_source,
  $download_user                     = $xldeploy::params::download_user,
  $download_password                 = $xldeploy::params::download_password,
  $download_proxy_url                = $xldeploy::params::download_proxy_url,
  $use_exported_resources            = $xldeploy::params::use_exported_resources,
  $use_exported_keys                 = $xldeploy::params::use_exported_keys,
  $client_propagate_key              = $xldeploy::params::client_propagate_key,
  $java_home                         = $xldeploy::params::java_home,
  $install_java                      = $xldeploy::params::install_java,
  $install_license                   = $xldeploy::params::install_license,
  $enable_housekeeping               = $xldeploy::params::enable_housekeeping,
  $housekeeping_minute               = $xldeploy::params::housekeeping_minute,
  $housekeeping_hour                 = $xldeploy::params::housekeeping_hour,
  $housekeeping_month                = $xldeploy::params::housekeeping_month,
  $housekeeping_monthday             = $xldeploy::params::housekeeping_monthday,
  $housekeeping_weekday              = $xldeploy::params::housekeeping_weekday,
  $ldap_server_id                    = $xldeploy::params::ldap_server_id,
  $ldap_server_url                   = $xldeploy::params::ldap_server_url,
  $ldap_server_root                  = $xldeploy::params::ldap_server_root,
  $ldap_manager_dn                   = $xldeploy::params::ldap_manager_dn,
  $ldap_manager_password             = $xldeploy::params::ldap_manager_password,
  $ldap_user_search_filter           = $xldeploy::params::ldap_user_search_filter,
  $ldap_user_search_base             = $xldeploy::params::ldap_user_search_base,
  $ldap_group_search_filter          = $xldeploy::params::ldap_group_search_filter,
  $ldap_group_search_base            = $xldeploy::params::ldap_group_search_base,
  $ldap_role_prefix                  = $xldeploy::params::ldap_role_prefix,
  $xldeploy_authentication_providers = $xldeploy::params::xldeploy_authentication_providers,
  $repository_type                   = $xldeploy::params::repository_type,
  $datastore_driver                  = $xldeploy::params::datastore_driver,
  $datastore_url                     = $xldeploy::params::datastore_url,
  $datastore_user                    = $xldeploy::params::datastore_user,
  $datastore_password                = $xldeploy::params::datastore_password,
  $datastore_databasetype            = $xldeploy::params::datastore_databasetype,
  $datastore_schema                  = $xldeploy::params::datastore_schema,
  $datastore_persistencemanagerclass = $xldeploy::params::datastore_persistencemanagerclass,
  $datastore_jdbc_driver_url         = $xldeploy::params::datastore_jdbc_driver_url,
  $disable_firewall                  = $xldeploy::params::disable_firewall,
  $ssl                               = $xldeploy::params::ssl,
  $verify_ssl                        = $xldeploy::params::verify_ssl,
  $xld_max_threads                   = $xldeploy::params::xld_max_threads,
  $xld_min_threads                   = $xldeploy::params::xld_min_threads,
  $xld_community_edition             = $xldeploy::params::xld_community_edition,
  $custom_productname                = undef,
  $custom_download_server_url        = undef,
  $custom_download_cli_url           = undef,
  $custom_os_user                    = undef,
  $custom_os_group                   = undef,
  $custom_license_source             = undef,
  $server_plugins                    = { } ,
  $cis                               = { } ,
  $memberships                       = { } ,
  $users                             = { } ,
  $roles                             = { } ,
  $dictionary_settings               = { } ,
  $role_permissions                  = { } ,
  $xldeploy_default_settings         = { }
  ) inherits xldeploy::params {
  # composed variables

  # support the community edition of xl-deploy
  if str2bool($xld_community_edition) {
    notify{'true':}
    $community_addon = "-free-edition"
    $license_source = $custom_license_source
  } else {
    notify{'false':}
    notify{$xld_community_edition:}
    $community_addon = ""
    $license_source  = 'https://tech.xebialabs.com/download/licenses/download/deployit-license.lic'
  }

  #we need to support the two different download urls for xldeploy and deployit
    if ($custom_download_server_url == undef) or ($custom_download_cli_url == undef) {
      if versioncmp($version , '3.9.90') > 0 {
        $download_server_url = "https://tech.xebialabs.com/download/xl-deploy/${version}/xl-deploy-${version}-server${community_addon}.zip"
        $download_cli_url    = "https://tech.xebialabs.com/download/xl-deploy/${version}/xl-deploy-${version}-cli${community_addon}.zip"
      } else {
        $download_server_url = "https://tech.xebialabs.com/download/deployit/${version}/deployit-${version}-server.zip"
        $download_cli_url    = "https://tech.xebialabs.com/download/deployit/${version}/deployit-${version}-cli.zip"
      }
    } else {
        $download_server_url = $custom_download_server_url
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

  if str2bool($::ssl) {
    $rest_protocol = 'https://'
    # Check certificate validation
    $verify_ssl = str2bool($::verify_ssl)
  } else {
    $rest_protocol = 'http://'
  }

  if $http_context_root == '/' {
    $rest_url = "${rest_protocol}${rest_user}:${rest_password}@${http_server_address}:${http_port}/deployit"
  } else {
    if $http_context_root =~ /^\// {
      $rest_url = "${rest_protocol}${rest_user}:${rest_password}@${http_server_address}:${http_port}${http_context_root}/deployit"
    } else {
      $rest_url = "${rest_protocol}${rest_user}:${rest_password}@${http_server_address}:${http_port}/${http_context_root}/deployit"
    }
  }
  
  
  $base_dir            = "${xldeploy_base_dir}/${productname}"
  $server_home_dir     = "${base_dir}/${productname}-server"
  $cli_home_dir        = "${base_dir}/${productname}-cli"
  $key_path            = "${server_home_dir}/keys"
  
  # include validation class to check our input
  include xldeploy::server::validation

  # to serve or not to server

  anchor    { 'xldeploy::server::begin': }
    -> Class  [ 'xldeploy::shared_prereq' ]
    -> class  { 'xldeploy::server::install': }
    -> class  { 'xldeploy::server::install_sshkey': }
    -> class  { 'xldeploy::server::config': }
    -> class  { 'xldeploy::server::repository': }
    ~> class  { 'xldeploy::server::security': }
    ~> class  { 'xldeploy::server::service': }
    -> class  { 'xldeploy::server::post_config': }
    -> anchor { 'xldeploy::server::end': }

  if str2bool($enable_housekeeping)  {

    class { 'xldeploy::server::housekeeping': } -> Class['xldeploy::server::post_config']

    if !defined(Class['Xldeploy::Cli']) {
      class {'xldeploy::cli':
        install_java                => $install_java,
        version                     => $version,
        xldeploy_base_dir           => $xldeploy_base_dir,
        install_type                => $install_type,
        puppetfiles_xldeploy_source => $puppetfiles_xldeploy_source,
        download_user               => $download_user,
        download_password           => $download_password,
        download_proxy_url          => $download_proxy_url,
        java_home                   => $java_home,
        custom_download_cli_url     => $custom_download_cli_url,
        custom_productname          => $custom_productname,
      }

      -> Class['xldeploy::server::housekeeping']
    }
  }

  #class to setup shared stuff between cli and server installations
  if !defined(Class['xldeploy::shared_prereq']) {
    class{'xldeploy::shared_prereq':
      base_dir     => $base_dir,
      os_user      => $os_user,
      os_group     => $os_group,
      os_user_home => $server_home_dir,
      install_java => $install_java,
      java_home    => $java_home
    }
  }
}
