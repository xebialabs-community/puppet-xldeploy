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
class xldeploy::client::validation (
) {
  ## type validation
  # string validation
  validate_string($xldeploy::version)
  validate_string($xldeploy::os_user)
  validate_string($xldeploy::os_group)
  validate_string($xldeploy::admin_password)
  validate_string($xldeploy::jcr_repository_path)
  validate_string($xldeploy::importable_packages_path)
  validate_string($xldeploy::client_user_password)
  validate_string($xldeploy::client_user_password_salt)
  validate_string($xldeploy::repository_type)
  validate_string($xldeploy::datastore_driver)
  validate_string($xldeploy::datastore_url)
  validate_string($xldeploy::datastore_user)
  validate_string($xldeploy::datastore_password)
  validate_string($xldeploy::datastore_databasetype)
  validate_string($xldeploy::datastore_schema)
  validate_string($xldeploy::datastore_persistencemanagerclass)

  # path validation
  validate_absolute_path($xldeploy::base_dir)
  validate_absolute_path($xldeploy::server_home_dir)
  validate_absolute_path($xldeploy::cli_home_dir)
  validate_absolute_path($xldeploy::tmp_dir)
  validate_absolute_path($xldeploy::http_context_root)

  # ipadress validation
  validate_ipv4_address($xldeploy::http_bind_address)

  # boolean validation
  validate_bool(str2bool($xldeploy::server))
  validate_bool(str2bool($xldeploy::ssl))
  validate_bool(str2bool($xldeploy::client_sudo))
  validate_bool(str2bool($xldeploy::use_exported_resources))
  validate_bool(str2bool($xldeploy::use_exported_keys))
  validate_bool(str2bool($xldeploy::enable_housekeeping))
  validate_bool(str2bool($xldeploy::install_java))
  validate_bool(str2bool($xldeploy::client_propagate_key))

  # hash validation
  validate_hash($xldeploy::cis)
  validate_hash($xldeploy::memberships)
  validate_hash($xldeploy::roles)
  validate_hash($xldeploy::users)
  validate_hash($xldeploy::server_plugins)

  ## content validation
  # check validity of this module on the specific system
  case $::osfamily {
    'RedHat' : { }
    default  : { fail("operating system ${::operatingsystem} not supported") }
  }

  # install_type should be valid
  case $xldeploy::install_type {
    'puppetfiles' : {
    }
    'packages'    : {
    }
    default       : {
      fail("unsupported install_type parameter ${xldeploy::install_type} specified, should be one of: [puppetfiles, packages]")
    }
  }

  # repository_type should be valid
  case $xldeploy::repository_type {
    'standalone' : { }
    'database'   : { }
    default      : { fail('unsupported repository type specified. Must be one of: [standalone, database]') }
  }

  # Parameters are required when repository_type == 'database'
  if $xldeploy::repository_type == 'database' {
    if $xldeploy::datastore_driver       == nil { fail 'Database driver must be specified when using database repository type' }
    if $xldeploy::datastore_url          == nil { fail 'Database JDBC url must be specified when using database repository type' }
    if $xldeploy::datastore_user         == nil { fail 'Database user must be specified when using database repository type' }
    if $xldeploy::datastore_password     == nil { fail 'Database password must be specified when using database repository type' }
    if $xldeploy::datastore_databasetype == nil { fail 'Database database type must be specified when using database repository type' }
    if $xldeploy::datastore_schema       == nil { fail 'Database schema must be specified when using database repository type' }
    if $xldeploy::datastore_persistencemanagerclass == nil { fail 'Database persistence manager class must be specified when using database repository type' }
  }
}
