# define: config_ci
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
define xldeploy::client::config_ci(
  $type,
  $ensure                 = 'present',
  $properties             = {},
  $rest_url               = $xldeploy::client::rest_url,
  $discovery              = false,
  $discovery_max_wait     = '120',
  $use_exported_resources = $xldeploy::client::use_exported_resources
){

  # if the age exceeds the export_maxage and remove_when_expired is set to true then set ensure to absent
  if str2bool($use_exported_resources) {
    @@xldeploy::client::exported_ci{"${::hostname}_${name}":
      type               => $type,
      properties         => $properties,
      rest_url           => $rest_url,
      discovery          => $discovery,
      discovery_max_wait => $discovery_max_wait
    }

  }else{
    xldeploy_ci{ $name:
      ensure             => $ensure,
      type               => $type,
      properties         => $properties,
      discovery          => $discovery,
      discovery_max_wait => $discovery_max_wait,
      rest_url           => $rest_url }
    }
}
