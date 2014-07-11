# Class xldeploy::server::service
#
# This class manages the xldeploy service
class xldeploy::server::service (
  $productname = $xldeploy::server::productname,
) {
  service { $productname:
    ensure => running,
    enable => true,
  }
}
