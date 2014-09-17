require 'spec_helper'

describe 'xldeploy::client' do
  let(:facts) {{ :osfamily => 'RedHat',
                 :concat_basedir => '/var/tmp' }}

  context 'xldeploy class wit server set to false' do
    let(:params) {{ }}

    it { should contain_anchor('xldeploy::client::begin') }
    it { should contain_class('xldeploy::client::user') }
    it { should contain_class('xldeploy::client::gems') }
    it { should contain_class('xldeploy::client::config')}
    it { should contain_anchor('xldeploy::client::end') }
  end

end #describe xldeploy
