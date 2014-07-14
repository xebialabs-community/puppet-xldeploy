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
  validate_string($xldeploy::importable_packages_path)
  validate_string($xldeploy::client_user_password)
  validate_string($xldeploy::client_user_password_salt)

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




}
