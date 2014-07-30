#class xldeploy::security
#
# This class takes care of the security configuration on which xldeploy relies to authenticate users.
#
# == Params
#
class xldeploy::security(
  $server_home_dir                   = $xldeploy::server_home_dir,
  $os_user                           = $xldeploy::os_user,
  $os_group                          = $xldeploy::os_group,
  $ldap_server_id                    = $xldeploy::ldap_server_id,
  $ldap_server_url                   = $xldeploy::ldap_server_url,
  $ldap_server_root                  = $xldeploy::ldap_server_root,
  $ldap_manager_dn                   = $xldeploy::ldap_manager_dn,
  $ldap_manager_password             = $xldeploy::ldap_manager_password,
  $ldap_user_search_filter           = $xldeploy::ldap_user_search_filter,
  $ldap_user_search_base             = $xldeploy::ldap_user_search_base,
  $ldap_group_search_filter          = $xldeploy::ldap_group_search_filter,
  $ldap_group_search_base            = $xldeploy::ldap_group_search_base,
  $ldap_role_prefix                  = $xldeploy::ldap_role_prefix,
  $xldeploy_authentication_providers = $xldeploy::xldeploy_authentication_providers,
  ){

  # flow

  # variables
  $security_config_file = "${server_home_dir}/conf/deployit-security.xml"

  # resources

  concat{$security_config_file:
    ensure => present,
    owner  => $os_user,
    group  => $os_group,
    mode   => '0640'
    }

  concat::fragment{'security_header':
    ensure   => present,
    target   => $security_config_file,
    content  => template('xldeploy/security/security-header.xml.erb'),
    order    => '10',
  }
  concat::fragment{'security_footer':
    ensure   => present,
    target   => $security_config_file,
    content  => template('xldeploy/security/security-footer.xml.erb'),
    order    => '90',
  }

  if $xldeploy_authentication_providers {
    concat::fragment{'security_beans':
      ensure   => present,
      target   => $security_config_file,
      content  => template('xldeploy/security/security-beans.xml.erb'),
      order    => '20',
    }
  }

  if $ldap_server_id {
    concat::fragment{'security_ldapserver':
      ensure  => present,
      target  => $security_config_file,
      content => template('xldeploy/security/security-ldapserver.xml.erb'),
      order   => '30',
    }
  }
  concat::fragment{'security_authentication_manager':
    ensure  => present,
    target  => $security_config_file,
    content => template('xldeploy/security/security-authentication-manager.xml.erb'),
    order   => '40',
  }
}
