#define: wrappersetting
# a defined resource that keeps track of xldeploy wrapper settings as set in the
# $server_home_dir/conf/xld-wrapper-linux.conf file
define xldeploy::resources::wrappersetting (
  $value,
  $key = $name,
  $ensure = present,
  $server_home_dir = $xldeploy::server::server_home_dir
  ) {

  $defaultFile = "${server_home_dir}/conf/xld-wrapper-linux.conf"

  ini_setting { $name:
    ensure            => $ensure,
    setting           => $key,
    value             => $value,
    path              => $defaultFile,
    key_val_separator => '=',
    section           => ''
  }

}
