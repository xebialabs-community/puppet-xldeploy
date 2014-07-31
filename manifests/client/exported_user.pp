# define: exported_user
#
# This define handles the export of xldeploy_user if this module is used in conjunction with shared resources
# The trick here is that the puppet run is able to determine if a xldeploy user is too old to maintain
# and should be removed from the xldeploy configuration once the last export is too long ago.
#
#
# == parameters
#
# [*password*]
# [*export_timestamp*]
# [*remove_when_expired*]
# [*export_maxage*]
define xldeploy::client::exported_user(
  $password,
  $rest_url            = $xldeploy::client::rest_url
){


  $user_name = split($name, '_')


  if !defined(Xldeploy_user[$user_name[1]]) {
    xldeploy_user{$user_name[1]:
      ensure             => present,
      password           => $password,
      rest_url           => $rest_url
    }
  }
}
