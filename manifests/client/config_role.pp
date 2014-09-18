# define: config_role
#
# This define handles the export of xldeploy_role if this module is used in conjunction with shared resources
# The trick here is that the puppet run is able to determine if a xldeploy role is too old to maintain
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
define xldeploy::client::config_role(
  $ensure                 = 'present',
  $id                     = $name,
  $granted_permissions    = {},
  $users                  = [ ],
  $rest_url               = $xldeploy::client::rest_url,
  $use_exported_resources = $xldeploy::client::use_exported_resources
){

  # if the age exceeds the export_maxage and remove_when_expired is set to true then set ensure to absent
  if str2bool($use_exported_resources) {
    @@xldeploy::client::exported_role{"${::hostname}_${id}":
      granted_permissions => $granted_permissions,
      users               => $users,
      rest_url            => $rest_url
    }

  }else{
    xldeploy_role{ $id:
      ensure              => $ensure,
      granted_permissions => $granted_permissions,
      users               => $users,
      rest_url            => $rest_url }
    }
}
