require 'spec_helper'

describe 'xldeploy::server::housekeeping' do


  context 'with default parameters' do
    let(:facts) { {:osfamily => 'RedHat',
                   :concat_basedir => '/var/tmp'} }

    let(:params) { {
                    :os_user => 'xldeploy',
                    :os_group => 'xldeploy',
                    :http_port => '4516',
                    :server_home_dir => '/opt/xl-deploy/server',
                    :cli_home_dir => '/opt/xl-deploy/cli'
                  } }

    it { should contain_file('/opt/xl-deploy/server/scripts/xldeploy-housekeeping.sh').with_ensure('present')}
    it { should contain_file('/opt/xl-deploy/server/scripts/garbage-collector.py').with_ensure('absent')}
    it { should contain_cron('xldeploy-housekeeping').with_ensure('present').with_command('/opt/xl-deploy/server/scripts/xldeploy-housekeeping.sh')}

  end
end
