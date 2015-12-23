# define: config_members
#
#
#
# == parameters
#
# [*export_timestamp*]
# [*remove_when_expired*]
# [*export_maxage*]
define xldeploy::client::config_members(
  $env,
  $members,
  $dictionaries,
  $rest_url               = $xldeploy::client::rest_url,
  $use_exported_resources = $xldeploy::client::use_exported_resources
){

  # if the age exceeds the export_maxage and remove_when_expired is set to true then set ensure to absent
  if str2bool($use_exported_resources) {
    @@xldeploy::client::exported_members{"${::hostname}__${name}":
      env          => $env,
      dictionaries => $dictionaries,
      members      => $members,
      rest_url     => $rest_url,
    }

  }else{
    xldeploy_environment_member{ $name:
      env          => $env,
      dictionaries => $dictionaries,
      members      => $members,
      rest_url     => $rest_url }
    }
}
