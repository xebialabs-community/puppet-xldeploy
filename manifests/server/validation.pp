# == Class: xldeploy:validation
#
# This class will validate all parameters available in the class xldeploy
#
# === Parameters
#
# See below
#
# === Copyright
#
# Copyright (c) 2014, Xebia Nederland b.v., All rights reserved.
#
class xldeploy::server::validation (
) {
  ## type validation
  # string validation
  validate_string($xldeploy::server::version)
  validate_string($xldeploy::server::os_user)
  validate_string($xldeploy::server::os_group)
  validate_string($xldeploy::server::admin_password)
  validate_string($xldeploy::server::jcr_repository_path)
  validate_string($xldeploy::server::importable_packages_path)
  validate_string($xldeploy::server::repository_type)
  validate_string($xldeploy::server::datastore_driver)
  validate_string($xldeploy::server::datastore_url)
  validate_string($xldeploy::server::datastore_user)
  validate_string($xldeploy::server::datastore_password)
  validate_string($xldeploy::server::datastore_databasetype)
  validate_string($xldeploy::server::datastore_schema)
  validate_string($xldeploy::server::datastore_persistencemanagerclass)

  # path validation
  validate_absolute_path($xldeploy::server::base_dir)
  validate_absolute_path($xldeploy::server::server_home_dir)
  validate_absolute_path($xldeploy::server::cli_home_dir)
  validate_absolute_path($xldeploy::server::tmp_dir)
  validate_absolute_path($xldeploy::server::http_context_root)

  # ipadress validation
  validate_ipv4_address($xldeploy::server::http_bind_address)

  # boolean validation
  validate_bool(str2bool($xldeploy::server::server))
  validate_bool(str2bool($xldeploy::server::ssl))
  validate_bool(str2bool($xldeploy::server::client_sudo))
  validate_bool(str2bool($xldeploy::server::use_exported_resources))
  validate_bool(str2bool($xldeploy::server::use_exported_keys))
  validate_bool(str2bool($xldeploy::server::enable_housekeeping))
  validate_bool(str2bool($xldeploy::server::install_java))
  validate_bool(str2bool($xldeploy::server::client_propagate_key))
  validate_bool(str2bool($xldeploy::server::disable_firewall))

  # hash validation
  validate_hash($xldeploy::server::cis)
  validate_hash($xldeploy::server::memberships)
  validate_hash($xldeploy::server::roles)
  validate_hash($xldeploy::server::users)
  validate_hash($xldeploy::server::server_plugins)



  ## content validation
  # check validity of this module on the specific system
  case $::osfamily {
    'RedHat' : { }
    'Debian' : { }
    default  : { fail("operating system ${::operatingsystem} not supported") }
  }

  # install_type should be valid
  case $xldeploy::server::install_type {
    'puppetfiles' : {
    }
    'download'    : {
    }
    default       : {
      fail("unsupported install_type parameter ${xldeploy::server::install_type} specified, should be one of: [puppetfiles, download]")
    }
  }

  # repository_type should be valid
  case $xldeploy::server::repository_type {
    'standalone' : { }
    'database'   : { }
    default      : { fail('unsupported repository type specified. Must be one of: [standalone, database]') }
  }

  # Parameters are required when repository_type == 'database'
  if $xldeploy::server::repository_type == 'database' {
    if $xldeploy::server::datastore_driver       == nil { fail 'Database driver must be specified when using database repository type' }
    if $xldeploy::server::datastore_url          == nil { fail 'Database JDBC url must be specified when using database repository type' }
    if $xldeploy::server::datastore_user         == nil { fail 'Database user must be specified when using database repository type' }
    if $xldeploy::server::datastore_password     == nil { fail 'Database password must be specified when using database repository type' }
    if $xldeploy::server::datastore_databasetype == nil { fail 'Database database type must be specified when using database repository type' }
    if $xldeploy::server::datastore_schema       == nil { fail 'Database schema must be specified when using database repository type' }
    if $xldeploy::server::datastore_persistencemanagerclass == nil { fail 'Database persistence manager class must be specified when using database repository type' }
  }
}
