#Class xldeploy::params
#
# Default parameters for xldeploy
#
class xldeploy::params {

  # os dependant variables
  case $::osfamily {
    'RedHat' : {
                  $java_home = '/usr/lib/jvm/jre-1.7.0-openjdk.x86_64'
                }
    'Debian' : {
                  $java_home = '/usr/lib/jvm/java-7-openjdk-amd64'
                }
    default  : { fail("operating system ${::operatingsystem} not supported") }
  }



  $version         = '4.5.0'
  $tmp_dir         = '/var/tmp'
  $server          = true
  $import_ssh_key  = false
  $xldeploy_base_dir  = '/opt'
  $xldeploy_init_repo = true
  $ssl                      = false
  $verify_ssl               = true
  $http_bind_address        = '0.0.0.0'
  $http_server_address      = $::fqdn
  $http_port                = '4516'
  $http_context_root        = '/deployit'
  $rest_user                = 'admin'
  $rest_password            = xldeploy_credentials('admin_password', 'xebialabs')
  $admin_password           = xldeploy_credentials('admin_password', 'xebialabs')
  $jcr_repository_path      = 'repository'
  $importable_packages_path = 'importablePackages'

  $xld_max_threads          = '24'
  $xld_min_threads          = '4'

  $manage_user                = true
  $os_user                    = 'xldeploy'
  $os_group                   = 'xldeploy'
  $os_user_home               = '/home/xldeploy'
  $os_user_manage             = true
  $client_sudo                = true
  $client_user_password       = 'xldeploy'
  $client_user_password_salt  = 'H8kV96rb'
  $client_propagate_key       = true
  $use_exported_resources     = false
  $use_exported_keys          = false
  $install_java               = true
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
  $puppetfiles_xldeploy_source  = undef
  $download_user                = undef
  $download_password            = undef
  $download_proxy_url           = undef

  # housekeeping defaults
  $enable_housekeeping        = true
  $housekeeping_minute        = 5
  $housekeeping_hour          = 2
  $housekeeping_month         = undef
  $housekeeping_monthday      = undef
  $housekeeping_weekday       = undef

  # license stuff
  $install_license              = true


}

