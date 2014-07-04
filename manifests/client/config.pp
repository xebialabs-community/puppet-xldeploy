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
  $rest_url               = $xldeploy::rest_url,
  $cis                    = $xldeploy::cis,
  $memberships            = $xldeploy::memberships,
  $users                  = $xldeploy::users,
  $roles                  = $xldeploy::roles,
  $dictionary_settings    = $xldeploy::dictionary_settings,
  $role_permissions       = $xldeploy::role_permissions,
  $use_exported_resources = $xldeploy::use_exported_resources,
  $use_exported_keys      = $xldeploy::use_exported_keys,
  $os_user                = $xldeploy::os_user,){


  create_resources(xldeploy::client::config_ci, $cis)

  create_resources(xldeploy::client::config_members, $memberships)

  create_resources(xldeploy::client::config_user, $users)

  create_resources(xldeploy::client::config_role, $roles)

  create_resources(xldeploy::client::config_role_permission, $role_permissions)

  create_resources(xldeploy::client::config_dictionary_entry, $dictionary_settings)




}
