# define: exported_members
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
define xldeploy::client::exported_members(
  $env,
  $members             = {},
  $dictionaries        = {},
  $rest_url            = $xldeploy::rest_url
){


  if !defined(Xldeploy_environment_member[$name]) {
    xldeploy_environment_member{$name:
      ensure             => present,
      env                => $env,
      members            => $members,
      dictionaries       => $dictionaries,
      rest_url           => $rest_url
    }
  }
}
