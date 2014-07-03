# Class xldeployit::post_config
#
# imports various exported resources
class xldeployit::post_config (
  $rest_url               = $xldeployit::rest_url,
  $http_server_address    = $xldeployit::http_server_address,
  $http_port              = $xldeployit::http_port,
  $use_exported_resources = $xldeployit::use_exported_resources,
  $use_exported_keys      = $xldeployit::use_exported_keys,
  $cis                    = $xldeployit::cis,
  $memberships            = $xldeployit::memberships,
  $users                  = $xldeployit::users,
  $roles                  = $xldeployit::roles,
  $dictionary_settings    = $xldeployit::dictionary_settings
) {


  # set rest_url as a default to use with configurable stuff
  $defaults = { rest_url => $rest_url,
                require => Xldeployit_check_connection['default']}

  # Check connection
  xldeployit_check_connection{'default':
    host => $http_server_address,
    port => $http_port
  }

  # config stuff in xldeployit
  create_resources(xldeployit_ci, $cis, $defaults)
  create_resources(xldeployit_environment_member, $memberships, $defaults)
  create_resources(xldeployit_dictionary_entry, $dictionary_settings, $defaults)
  create_resources(xldeployit_user, $users, $defaults)
  create_resources(xldeployit_role, $roles, $defaults)


  # handle exported resources
  if str2bool($use_exported_resources) {


    Xldeployit_check_connection['Default']

    #import exported configuration items
    -> Xldeployit::Client::Exported_ci <<| |>> {
      rest_url => $rest_url
    }
    -> Xldeployit::Client::Exported_members <<| |>> {
      rest_url => $rest_url
    }
    -> Xldeployit::Client::Exported_user <<| |>> {
      rest_url => $rest_url
    }
    -> Xldeployit::Client::Exported_role <<| |>> {
      rest_url => $rest_url
    }
    -> Xldeployit::Client::Exported_role_permission <<| |>> {
      rest_url => $rest_url
    }
    -> Xldeployit::Client::Exported_dictionary_entry <<| |>> {
      rest_url => $rest_url
    }
  }


}
