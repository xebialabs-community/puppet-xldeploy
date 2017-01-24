#installs a default sshkey in the xldeploy homedir which will be the default for communication with the nodes
#We use the jtopjian/sshkeys module for this so we can push the module through a fact to puppetdb where available
#this way the key can be imported on a client install
#
# TODO: support more key types
#
class xldeploy::server::install_sshkey(
  $server_home_dir = $xldeploy::server::server_home_dir,
  $os_user         = $xldeploy::server::os_user,
  $manage_keys     = $xldeploy::server::manage_keys
){
  if $manage_keys {
    # flow
    Xldeploy::Resources::Defaultsetting['overthere.SshHost.privateKeyFile']
    -> Sshkeys::Create_Ssh_key[$os_user]

    # call a nice little parser function to generate a random passphrase
    $keyfile_passphrase = random_passphrase()

    sshkeys::create_ssh_key { $os_user:
      passphrase  => $keyfile_passphrase,
      notify      => Xldeploy::Resources::Defaultsetting['overthere.SshHost.passphrase']
    }

    xldeploy::resources::defaultsetting{'overthere.SshHost.passphrase':
    value       => $keyfile_passphrase,
    }

    xldeploy::resources::defaultsetting{'overthere.SshHost.privateKeyFile':
    value => "${server_home_dir}/.ssh/id_rsa"
    }
  }

}