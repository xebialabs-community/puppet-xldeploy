# define: exported_key
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
define xldeploy::client::exported_key(
  $key_tag,
  $key_path            = $xldeploy::key_path,
  $os_user             = $xldeploy::os_user,
  $os_group            = $xldeploy::os_group
){



  if !defined(File["${key_path}/${name}"]){
    file{"${key_path}/${name}":
      ensure             => $ensure,
      content            => get_xldeploy_key('private', $key_tag),
      mode               => '0600',
      owner              => $os_user,
      group              => $os_group
    }
  }
}
