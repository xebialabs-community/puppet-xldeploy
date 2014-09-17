require 'spec_helper'

describe 'xldeploy::cli' do
  let(:facts) {{ :osfamily => 'RedHat',
                 :concat_basedir => '/var/tmp' }}

  context 'xldeploy cli class' do
    let(:params) {{ }}

    it { should contain_anchor('xldeploy::cli::begin') }
    it { should contain_class('xldeploy::cli::install') }
    it { should contain_class('xldeploy::cli::end') }
  end

end #describe xldeploy
