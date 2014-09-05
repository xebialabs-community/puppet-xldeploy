#Class xldeploy::params
#
# Default parameters for xldeploy
#
class xldeploy::params {
  $version         = '4.0.1'
  $tmp_dir         = '/var/tmp'
  $server          = true
  $os_user         = 'xldeploy'
  $os_group        = 'xldeploy'
  $import_ssh_key  = false
  $xldeploy_base_dir = '/opt'
  $ssl             = false
  $http_bind_address        = '0.0.0.0'
  $http_server_address      = $::fqdn
  $http_port                = '4516'
  $http_context_root        = '/deployit'
  $admin_password           = xldeploy_credentials('admin_password', 'admin')
  $jcr_repository_path      = 'repository'
  $importable_packages_path = 'importablePackages'



  $client_sudo                = true
  $client_user_password       = 'xldeploy'
  $client_user_password_salt  = 'H8kV96rb'
  $client_propagate_key       = true
  $use_exported_resources     = false
  $use_exported_keys          = false
  $enable_housekeeping        = true
  $java_home                  = '/usr/lib/jvm/jre-1.7.0-openjdk.x86_64'
  $install_java               = false
  $disable_firewall           = true

  #security settings
  $xldeploy_authentication_providers = {'rememberMeAuthenticationProvider' => 'com.xebialabs.deployit.security.authentication.RememberMeAuthenticationProvider',
                                        'jcrAuthenticationProvider' => 'com.xebialabs.deployit.security.authentication.JcrAuthenticationProvider'}
  $ldap_server_id                    = undef
  $ldap_server_url                   = undef
  $ldap_server_root                  = undef
  $ldap_manager_dn                   = undef
  $ldap_manager_password             = undef
  $ldap_user_search_filter           = undef
  $ldap_user_search_base             = undef
  $ldap_group_search_filter          = undef
  $ldap_group_search_base            = undef
  $ldap_role_prefix                  = undef

  # Either 'standalone' or 'database'
  $repository_type                   = 'standalone'

  # Only used when repository_type == 'database'
  $datastore_driver                  = undef
  $datastore_url                     = undef
  $datastore_user                    = undef
  $datastore_password                = undef
  $datastore_databasetype            = undef
  $datastore_schema                  = undef
  $datastore_persistencemanagerclass = undef
  $datastore_jdbc_driver_url         = undef


  # installation related params
  $install_type                 = 'download'
  $puppetfiles_xldeploy_source  = 'puppet:///modules/xldeploy/sources'
  $download_user                = undef
  $download_password            = undef
  $download_proxy_url           = undef

  # license stuff
  $install_license              = true
  $license_source               = 'https://tech.xebialabs.com/download/licenses/download/deployit-license.lic'

  # gem stuff .. will be removed when we get around to refactoring the gems
  $gem_use_local   = true

  $gem_hash        = {
    'mime-types'  => {
      'source'  => 'puppet:///modules/xldeploy/gems/mime-types-1.25.1.gem',
      'version' => '1.25.1'
  }
  ,
    'xml-simple'  => {
      'source'  => 'puppet:///modules/xldeploy/gems/xml-simple-1.1.2.gem',
      'version' => '1.1.2'
  }
  ,
    'rest-client' => {
      'source'  => 'puppet:///modules/xldeploy/gems/rest-client-1.6.7.gem',
      'version' => '1.6.7'
  }
  }

  $gem_array       = ['xml-simple', 'rest-client']


}

