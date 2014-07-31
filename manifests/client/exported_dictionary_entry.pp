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
define xldeploy::client::exported_dictionary_entry(
  $value,
  $rest_url            = $xldeploy::client::rest_url,
){


  $dict_id = split($name, '_')



  if !defined(Xldeploy_dictionary_entry[$dict_id[1]]) {
    xldeploy_dictionary_entry{$dict_id[1]:
      ensure             => present,
      value              => $value,
      rest_url           => $rest_url
    }
  }
}
