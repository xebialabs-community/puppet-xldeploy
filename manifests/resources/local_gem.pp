# xldeploy::resources::local_gem
#  This defined type can be uses to install gems where rubygems dot.org can not be used
#  Make sure that the source of you gem is in you module under file/gems
define xldeploy::resources::local_gem (
  $source,
  $version,
  $provider = 'gem') {
  file { "/var/tmp/${name}-${version}.gem":
    ensure => present,
    source => $source
  }

  package { $name:
    ensure   => present,
    source   => "/var/tmp/${name}-${version}.gem",
    provider => $provider,
  }
}
