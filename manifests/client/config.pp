#== Class: xldeploy::client::config
#
# This class takes care of the configuration of xldeploy external nodes
# === Examples
#
#
#
# === Parameters
#
#
# === Copyright
#
# Copyright (c) 2013, Xebia Nederland b.v., All rights reserved.
#
class xldeploy::client::config(
  $rest_url               = $xldeploy::client::rest_url,
  $cis                    = $xldeploy::client::cis,
  $memberships            = $xldeploy::client::memberships,
  $users                  = $xldeploy::client::users,
  $roles                  = $xldeploy::client::roles,
  $dictionary_settings    = $xldeploy::client::dictionary_settings,
  $role_permissions       = $xldeploy::client::role_permissions,
  $use_exported_resources = $xldeploy::client::use_exported_resources,
  $use_exported_keys      = $xldeploy::client::use_exported_keys,
  $os_user                = $xldeploy::client::os_user,){

  # set rest_url as a default to use with configurable stuff
  $defaults = { rest_url => $rest_url,
                require  => Xldeploy_check_connection['client']}

  # Check connection
  xldeploy_check_connection{'client':
    rest_url => $rest_url
  }

  create_resources(xldeploy::client::config_ci, $cis, $defaults)

  create_resources(xldeploy::client::config_members, $memberships, $defaults)

  create_resources(xldeploy::client::config_user, $users, $defaults)

  create_resources(xldeploy::client::config_role, $roles, $defaults)

  create_resources(xldeploy::client::config_role_permission, $role_permissions, $defaults)

  create_resources(xldeploy::client::config_dictionary_entry, $dictionary_settings, $defaults)




}
