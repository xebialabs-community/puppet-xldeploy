#
class xldeploy::shared_prereq(
  $base_dir,
  $os_user,
  $os_group,
  $os_user_home,
  $install_java,
  $java_home
){

  # make sure unzip is on the machine
  ensure_packages(['unzip'])

  # install java packages if needed
  if str2bool($install_java) {
    case $::osfamily {
      'RedHat' : {
          $java_packages = ['java-1.7.0-openjdk']
          ensure_packages($java_packages)
      }
      'Debian' : {
          $java_packages = ['openjdk-7-jdk']
          ensure_packages($java_packages)
      }
      default  : {
          fail("${::osfamily}:${::operatingsystem} not supported by this module")
      }
    }
  }

  # user and group

  group { $os_group: ensure => 'present' }

  user { $os_user:
    ensure     => present,
    gid        => $os_group,
    managehome => false,
    home       => $os_user_home
  }

  # base dir

  file { $base_dir:
    ensure => directory,
    owner  => $os_user,
    group  => $os_group,
  }



}
