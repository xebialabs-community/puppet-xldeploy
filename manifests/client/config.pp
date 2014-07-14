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


  create_resources(xldeploy::client::config_ci, $cis)

  create_resources(xldeploy::client::config_members, $memberships)

  create_resources(xldeploy::client::config_user, $users)

  create_resources(xldeploy::client::config_role, $roles)

  create_resources(xldeploy::client::config_role_permission, $role_permissions)

  create_resources(xldeploy::client::config_dictionary_entry, $dictionary_settings)




}
