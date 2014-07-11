require 'spec_helper'

describe 'xldeploy::server' do
  let(:facts) {{ :osfamily => 'RedHat',
                 :concat_basedir => '/var/tmp' }}

  context 'supported operating systems' do
    ['RedHat'].each do |osfamily|
      describe "xldeploy class without any parameters on #{osfamily}" do

        let(:params) {{ }}
        let(:facts) {{
            :osfamily => osfamily,
            :concat_basedir =>  '/var/tmp'
        }}

        it { should contain_class('xldeploy::params') }
        it { should contain_class('xldeploy::server::validation') }
      end
    end
  end

  context 'xldeploy class server stream (server parameter set to true)' do


    let(:params) {{  }}


      it { should contain_anchor('xldeploy::server::begin') }
      it { should contain_class('xldeploy::server::install') }
      it { should contain_class('xldeploy::server::config')}
      it { should contain_class('xldeploy::server::security')}
      it { should contain_class('xldeploy::server::service')}
      it { should contain_class('xldeploy::server::post_config')}
      it { should contain_anchor('xldeploy::server::end')}


  end

  context 'xldeploy class server + housekeeping set to true' do

    let(:params) {{ :enable_housekeeping => 'true' }}

    it { should contain_class('xldeploy::server::housekeeping')}
  end





end #describe xldeploy
