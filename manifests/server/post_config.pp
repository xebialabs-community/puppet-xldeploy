# Class xldeploy::server::post_config
#
# imports various exported resources
class xldeploy::server::post_config (
  $rest_url               = $xldeploy::server::rest_url,
  $http_server_address    = $xldeploy::server::http_server_address,
  $http_port              = $xldeploy::server::http_port,
  $use_exported_resources = $xldeploy::server::use_exported_resources,
  $use_exported_keys      = $xldeploy::server::use_exported_keys,
  $cis                    = $xldeploy::server::cis,
  $ssl                    = $xldeploy::server::ssl,
  $verify_ssl             = $xldeploy::server::verify_ssl,
  $memberships            = $xldeploy::server::memberships,
  $users                  = $xldeploy::server::users,
  $roles                  = $xldeploy::server::roles,
  $dictionary_settings    = $xldeploy::server::dictionary_settings
) {


  # set rest_url as a default to use with configurable stuff
  $defaults = { rest_url => $rest_url,
                require  => Xldeploy_check_connection['default']}

  unless empty($cis) and
         empty($membership) and
         empty($dictionary_settings) and
         empty($users) and
         empty($roles) {
  # Check connection
    ensure_resource('xldeploy_check_connection', 'default', {'rest_url' => $rest_url})

  # config stuff in xldeploy
    create_resources(xldeploy_ci, $cis, $defaults)
    create_resources(xldeploy_environment_member, $memberships, $defaults)
    create_resources(xldeploy_dictionary_entry, $dictionary_settings, $defaults)
    create_resources(xldeploy_user, $users, $defaults)
    create_resources(xldeploy_role, $roles, $defaults)
  }

  # handle exported resources
  if str2bool($use_exported_resources) {

    ensure_resource('xldeploy_check_connection', 'default', {'rest_url' => $rest_url})
    Xldeploy_check_connection['Default']

    #import exported configuration items
    -> Xldeploy::Client::Exported_ci <<| |>> {
      rest_url => $rest_url
    }
    -> Xldeploy::Client::Exported_members <<| |>> {
      rest_url => $rest_url
    }
    -> Xldeploy::Client::Exported_user <<| |>> {
      rest_url => $rest_url
    }
    -> Xldeploy::Client::Exported_role <<| |>> {
      rest_url => $rest_url
    }
    -> Xldeploy::Client::Exported_role_permission <<| |>> {
      rest_url => $rest_url
    }
    -> Xldeploy::Client::Exported_dictionary_entry <<| |>> {
      rest_url => $rest_url
    }
  }


}
