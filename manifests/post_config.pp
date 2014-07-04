# Class xldeploy::post_config
#
# imports various exported resources
class xldeploy::post_config (
  $rest_url               = $xldeploy::rest_url,
  $http_server_address    = $xldeploy::http_server_address,
  $http_port              = $xldeploy::http_port,
  $use_exported_resources = $xldeploy::use_exported_resources,
  $use_exported_keys      = $xldeploy::use_exported_keys,
  $cis                    = $xldeploy::cis,
  $memberships            = $xldeploy::memberships,
  $users                  = $xldeploy::users,
  $roles                  = $xldeploy::roles,
  $dictionary_settings    = $xldeploy::dictionary_settings
) {


  # set rest_url as a default to use with configurable stuff
  $defaults = { rest_url => $rest_url,
                require => Xldeploy_check_connection['default']}

  # Check connection
  xldeploy_check_connection{'default':
    host => $http_server_address,
    port => $http_port
  }

  # config stuff in xldeploy
  create_resources(xldeploy_ci, $cis, $defaults)
  create_resources(xldeploy_environment_member, $memberships, $defaults)
  create_resources(xldeploy_dictionary_entry, $dictionary_settings, $defaults)
  create_resources(xldeploy_user, $users, $defaults)
  create_resources(xldeploy_role, $roles, $defaults)


  # handle exported resources
  if str2bool($use_exported_resources) {


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
