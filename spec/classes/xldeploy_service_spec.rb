require 'spec_helper'

# TODO: check template content ..

describe 'xldeploy::service' do
  let(:facts) { {:osfamily       => 'RedHat',
                 :concat_basedir => '/var/tmp'} }

  let(:params) { {:os_user       => 'xldeploy' } }

  context 'default' do
    it {should contain_service('xldeploy').with_ensure('running')}
    it {should contain_file('/etc/init.d/xldeploy').with_content(/RUNNINGUSER="xldeploy"/)}
  end
end


