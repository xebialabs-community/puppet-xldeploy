require 'spec_helper'

describe 'xldeploy::server::service' do
  let(:facts) { {:osfamily       => 'RedHat',
                 :concat_basedir => '/var/tmp'}}

  let(:params) { {:productname   => 'xldeploy' }}

  context 'default' do
    it {should contain_service('xldeploy').with_ensure('running')}
  end
end


