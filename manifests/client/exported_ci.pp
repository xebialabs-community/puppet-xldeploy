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
define xldeploy::client::exported_ci(
  $type,
  $properties          = {},
  $rest_url            = $xldeploy::rest_url,
  $discovery           = false,
  $discovery_max_wait  = '120',
){


  $ci_id = split($name, '_')


  if !defined(Xldeploy_ci[$ci_id[1]]) {
    xldeploy_ci{$ci_id[1]:
      ensure             => present,
      type               => $type,
      properties         => $properties,
      discovery          => $discovery,
      discovery_max_wait => $discovery_max_wait,
      rest_url           => $rest_url
    }
  }
}
