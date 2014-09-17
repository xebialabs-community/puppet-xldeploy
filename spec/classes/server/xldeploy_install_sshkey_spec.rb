require 'spec_helper'

describe 'xldeploy::server::install_sshkey' do

  let(:facts) {{ :osfamily => 'RedHat',
                 :concat_basedir => '/var/tmp' }}

  context 'with defaults' do
    let(:params) {{ :os_user                     => 'xldeploy',
                    :server_home_dir             => '/opt/xldeploy/xldeploy-server',
                 }}


    it {should contain_sshkeys__create_key('xldeploy').with_home('/opt/xldeploy/xldeploy-server').with_manage_home('false')}
    it {should contain_xldeploy__resources__defaultsetting('overthere.SshHost.passphrase')}
    it {should contain_xldeploy__resources__defaultsetting('overthere.SshHost.privateKeyFile').with_value('/opt/xldeploy/xldeploy-server/.ssh/id_rsa')}
  end
end
