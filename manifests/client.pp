# = = Class: xldeploy
#
# This class installs xldeploy client
#
# === Examples
#
#  class { 'xldeploy::client':
#  }
#
# === Copyright
#
# Copyright (c) 2013, Xebia Nederland b.v., All rights reserved.
#
class xldeploy::client (
  $http_bind_address                 = $xldeploy::params::http_bind_address,
  $http_port                         = $xldeploy::params::http_port,
  $http_context_root                 = $xldeploy::params::http_context_root,
  $http_server_address               = $xldeploy::params::http_server_address,
  $ssl                               = $xldeploy::params::ssl,
  $verifySsl                         = $xldeploy::params::verifySsl,
  $rest_user                         = $xldeploy::params::rest_user,
  $rest_password                     = $xldeploy::params::rest_password,
  $client_sudo                       = $xldeploy::params::client_sudo,
  $client_user_password              = $xldeploy::params::client_user_password,
  $client_user_password_salt         = $xldeploy::params::client_user_password_salt,
  $use_exported_resources            = $xldeploy::params::use_exported_resources,
  $use_exported_keys                 = $xldeploy::params::use_exported_keys,
  $client_propagate_key              = $xldeploy::params::client_propagate_key,
  $gem_use_local                     = $xldeploy::params::gem_use_local,
  $gem_hash                          = $xldeploy::params::gem_hash,
  $gem_array                         = $xldeploy::params::gem_array,
  $manage_user                       = $xldeploy::params::manage_user,
  $custom_os_user                    = undef,
  $custom_os_group                   = undef,
  $custom_os_user_home               = undef,
  $cis                               = { } ,
  $memberships                       = { } ,
  $users                             = { } ,
  $roles                             = { } ,
  $dictionary_settings               = { } ,
  $role_permissions                  = { } ,
  ) inherits xldeploy::params {

  # include validation class to check our input
  include xldeploy::client::validation

  # composed variables

  if str2bool($::ssl) {
    $rest_protocol = 'https://'
    # Check certificate validation
    $verifySsl = str2bool($::verifySsl)
  } else {
    $rest_protocol = 'http://'
  }

  if $http_context_root == '/' {
    $rest_url = "${rest_protocol}${rest_user}:${rest_password}@${http_server_address}:${http_port}/deployit"
  } else {
    $rest_url = "${rest_protocol}${rest_user}:${rest_password}@${http_server_address}:${http_port}${http_context_root}/deployit"
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

  if ($custom_os_user_home == undef) {
      $os_user_home = "/home/${os_user}"
  } else {
      $os_user_home = $custom_os_user_home
  }

  anchor    { 'xldeploy::client::begin': }
  -> class  { 'xldeploy::client::gems':}
  -> class  { 'xldeploy::client::config': }
  -> anchor { 'xldeploy::client::end': }

  if ($manage_user == true) {
    Anchor['xldeploy::client::begin'] -> class {'xldeploy::client::user':} -> Class['xldeploy::client::gems']
  }

}
