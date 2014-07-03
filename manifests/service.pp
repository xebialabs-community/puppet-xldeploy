# Class xldeploy::service
#
# This class manages the xldeploy service
class xldeploy::service {
  service { 'xldeploy':
    ensure => running,
    enable => true,
  }
}
