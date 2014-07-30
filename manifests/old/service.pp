# Class xldeploy::service
#
# This class manages the xldeploy service
class xldeploy::service (
  $productname = $deployit::productname,
) {
  service { $productname:
    ensure => running,
    enable => true,
  }
}
