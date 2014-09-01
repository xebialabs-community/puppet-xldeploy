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
  $tmp_dir                           = $xldeploy::params::tmp_dir,
  $os_user                           = $xldeploy::params::os_user,
  $os_group                          = $xldeploy::params::os_group,
  $import_ssh_key                    = $xldeploy::params::import_ssh_key,
  $http_bind_address                 = $xldeploy::params::http_bind_address,
  $http_port                         = $xldeploy::params::http_port,
  $http_context_root                 = $xldeploy::params::http_context_root,
  $http_server_address               = $xldeploy::params::http_server_address,
  $admin_password                    = $xldeploy::params::admin_password,
  $jcr_repository_path               = $xldeploy::params::jcr_repository_path,
  $importable_packages_path          = $xldeploy::params::importable_packages_path,
  $client_sudo                       = $xldeploy::params::client_sudo,
  $client_user_password              = $xldeploy::params::client_user_password,
  $client_user_password_salt         = $xldeploy::params::client_user_password_salt,
  $install_type                      = $xldeploy::params::install_type,
  $puppetfiles_xldeploy_source       = $xldeploy::params::puppetfiles_xldeploy_source,
  $productname                       = $xldeploy::params::productname,
  $download_server_url               = $xldeploy::params::download_server_url,
  $download_cli_url                  = $xldeploy::params::download_cli_url,
  $download_user                     = $xldeploy::params::download_user,
  $download_password                 = $xldeploy::params::download_password,
  $download_proxy_url                = $xldeploy::params::download_proxy_url,
  $use_exported_resources            = $xldeploy::params::use_exported_resources,
  $use_exported_keys                 = $xldeploy::params::use_exported_keys,
  $client_propagate_key              = $xldeploy::params::client_propagate_key,
  $java_home                         = $xldeploy::params::java_home,
  $install_java                      = $xldeploy::params::install_java,
  $install_license                   = $xldeploy::params::install_license,
  $license_source                    = $xldeploy::params::license_source,
  $enable_housekeeping               = $xldeploy::params::enable_housekeeping,
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
  $gem_use_local                     = $xldeploy::params::gem_use_local,
  $gem_hash                          = $xldeploy::params::gem_hash,
  $gem_array                         = $xldeploy::params::gem_array,
  $disable_firewall                  = $xldeploy::params::disable_firewall,
  $server_plugins                    = { },
  $cis                               = { } ,
  $memberships                       = { } ,
  $users                             = { } ,
  $roles                             = { } ,
  $dictionary_settings               = { } ,
  $role_permissions                  = { } ,
  $xldeploy_default_settings         = { }
  ) inherits xldeploy::params {
  # composed variables



  # form the rest url for use throughout the rest of the module
  if str2bool($::ssl) {
    $rest_protocol = 'https://'
  } else {
    $rest_protocol = 'http://'
  }

  if $http_context_root == '/' {
    $rest_url = "${rest_protocol}admin:${admin_password}@${http_server_address}:${http_port}/deployit"
  } else {
    $rest_url = "${rest_protocol}admin:${admin_password}@${http_server_address}:${http_port}${http_context_root}/deployit"
  }

  #we need to support the two different download urls for xldeploy and deployit
  if ($download_server_url == undef) or ($download_cli_url == undef) or ($productname == undef) {
    if versioncmp($version , '3.9.90') > 0 {
      $download_server_url = "https://tech.xebialabs.com/download/xl-deploy/${version}/xl-deploy-${version}-server.zip"
      $download_cli_url    = "https://tech.xebialabs.com/download/xl-deploy/${version}/xl-deploy-${version}-cli.zip"
    } else {
      $download_server_url = "https://tech.xebialabs.com/download/deployit/${version}/deployit-${version}-server.zip"
      $download_cli_url    = "https://tech.xebialabs.com/download/deployit/${version}/deployit-${version}-cli.zip"
    }
  }

  # we need to support two different productnames
  if ($productname == undef) {
    if versioncmp($version , '3.9.90') > 0 {
      $productname         = 'xl-deploy'
    } else {
      $productname         = 'deployit'
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
  -> class  { 'xldeploy::server::install': }
  -> class  { 'xldeploy::server::install_sshkey': }
  -> class  { 'xldeploy::server::config': }
  -> class  { 'xldeploy::server::repository': }
  ~> class  { 'xldeploy::server::security': }
  ~> class  { 'xldeploy::server::service': }
  -> class  { 'xldeploy::server::gems': }
  -> class  { 'xldeploy::server::post_config': }
  -> anchor { 'xldeploy::server::end': }

  if str2bool($enable_housekeeping) {
    Class['xldeploy::server::service'] -> class { 'xldeploy::server::housekeeping': } -> Class['xldeploy::server::post_config']
  }

}
