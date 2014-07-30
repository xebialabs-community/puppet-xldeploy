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
class xldeploy::client (
  $os_user                           = $xldeploy::params::os_user,
  $os_group                          = $xldeploy::params::os_group,
  $http_bind_address                 = $xldeploy::params::http_bind_address,
  $http_port                         = $xldeploy::params::http_port,
  $http_context_root                 = $xldeploy::params::http_context_root,
  $http_server_address               = $xldeploy::params::http_server_address,
  $admin_password                    = $xldeploy::params::admin_password,
  $client_sudo                       = $xldeploy::params::client_sudo,
  $client_user_password              = $xldeploy::params::client_user_password,
  $client_user_password_salt         = $xldeploy::params::client_user_password_salt,
  $use_exported_resources            = $xldeploy::params::use_exported_resources,
  $use_exported_keys                 = $xldeploy::params::use_exported_keys,
  $client_propagate_key              = $xldeploy::params::client_propagate_key,
  $gem_use_local                     = $xldeploy::params::gem_use_local,
  $gem_hash                          = $xldeploy::params::gem_hash,
  $gem_array                         = $xldeploy::params::gem_array,
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
  } else {
    $rest_protocol = 'http://'
  }

  if $http_context_root == '/' {
    $rest_url = "${rest_protocol}admin:${admin_password}@${http_server_address}:${http_port}/deployit"
  } else {
    $rest_url = "${rest_protocol}admin:${admin_password}@${http_server_address}:${http_port}${http_context_root}/deployit"
  }

  anchor    { 'xldeploy::client::begin': }
  -> class  { 'xldeploy::client::user': }
  -> class  { 'xldeploy::gems':}
  -> class  { 'xldeploy::client::config': }
  -> anchor { 'xldeploy::client::end': }


}
