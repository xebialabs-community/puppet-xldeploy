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
  validate_string($xldeploy::client::version)
  validate_string($xldeploy::client::os_user)
  validate_string($xldeploy::client::os_group)
  validate_string($xldeploy::client::os_user_home)
  validate_string($xldeploy::client::rest_user)
  validate_string($xldeploy::client::rest_password)
  validate_string($xldeploy::client::importable_packages_path)
  validate_string($xldeploy::client::client_user_password)
  validate_string($xldeploy::client::client_user_password_salt)

  # boolean validation
  validate_bool(str2bool($xldeploy::client::ssl))
  validate_bool(str2bool($xldeploy::client::verifySsl))
  validate_bool(str2bool($xldeploy::client::os_user_manage))
  validate_bool(str2bool($xldeploy::client::client_sudo))
  validate_bool(str2bool($xldeploy::client::use_exported_resources))
  validate_bool(str2bool($xldeploy::client::use_exported_keys))
  validate_bool(str2bool($xldeploy::client::client_propagate_key))
  validate_bool(str2bool($xldeploy::client::manage_user))

  notice($xldeploy::client::cis)

  # hash validation
  validate_hash($xldeploy::client::cis)
  validate_hash($xldeploy::client::memberships)
  validate_hash($xldeploy::client::roles)
  validate_hash($xldeploy::client::users)

  ## content validation
  # check validity of this module on the specific system
  case $::osfamily {
    'RedHat' : { }
    'Debian' : { }
    default  : { fail("operating system ${::operatingsystem} not supported") }
  }




}
