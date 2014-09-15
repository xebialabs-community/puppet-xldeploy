# define: exported_ci
#
# This define handles the export of xldeploy_ci if this module is used in conjunction with shared resources
# The trick here is that the puppet run is able to determine if a xldeploy ci is too old to maintain
# and should be removed from the xldeploy configuration once the last export is too long ago.
#
#
# == parameters
#
# [*type*]
# [*properties*]
# [*discovery*]
# [*discovery_max_wait*]
# [*id*]
# [*export_timestamp*]
# [*remove_when_expired*]
# [*export_maxage*]
define xldeploy::client::exported_role_permission(
  $role,
  $cis,
  $granted_permissions,
  $rest_url            = $xldeploy::client::rest_url,
){


  $name_id = split($name, '_')

  if !defined(Xldeploy_role_permission[$name_id[1]]) {
    xldeploy_role_permission{$name_id[1]:
      role                 => $role,
      cis                  => $cis,
      granted_permissions  => $granted_permissions,
      rest_url             => $rest_url
    }
  }
}
