#define: default_setting
# a defined resource that keeps track of xldeploy default settings as set in the
# $server_home_dir/conf/xldeploy-defaults.properties file
# this file holds default properties for the various xldeploy configuration items
# xldeploy has a nasty habbit of changing it's own config files whenever it feels like it
# so we have to use ini_file to not keep changing this file over and over
define xldeploy::resources::defaultsetting (
  $value,
  $key = $name,
  $ensure = present
  ) {

  $server_home_dir = $xldeploy::server_home_dir
  $defaultFile = "${server_home_dir}/conf/deployit-defaults.properties"

  ini_setting { $name:
    ensure            => $ensure,
    setting           => $key,
    value             => $value,
    path              => $defaultFile,
    key_val_separator => '=',
    section           => ''
  }

}