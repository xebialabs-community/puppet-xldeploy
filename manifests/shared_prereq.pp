#
class xldeploy::shared_prereq(
  $base_dir,
  $os_user,
  $os_group,
  $os_user_home,
  $install_java,
  $java_home
){

  # install java packages if needed

  case $::osfamily {
    'RedHat' : {
        $java_package = ['java-1.7.0-openjdk']

      }
    'Debian' : {
        $java_package = ['openjdk-7-jdk']
        $unzip_packages = ['unzip']
        if !defined(Package[$unzip_packages]){
          package { $unzip_packages: ensure => present } -> User[$os_user]
        }
    }
    default  : {
        fail("${::osfamily}:${::operatingsystem} not supported by this module")
    }
  }

  if str2bool($install_java){
    if !defined(Package[$java_package]){
      package{$java_package:
        ensure => present
      }
    -> User[$os_user]
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