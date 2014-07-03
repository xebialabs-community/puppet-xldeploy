require 'spec_helper'

describe 'xldeploy' do
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
        it { should contain_class('xldeploy::validation') }
      end
    end
  end

  context 'xldeploy class server stream (server parameter set to true)' do


    let(:params) {{ :server => 'true' }}


      it { should contain_anchor('xldeploy::begin') }
      it { should contain_class('xldeploy::install') }
      it { should contain_class('xldeploy::utils')}
      it { should contain_class('xldeploy::config')}
      it { should contain_class('xldeploy::security')}
      it { should contain_class('xldeploy::service')}
      it { should contain_class('xldeploy::post_config')}
      it { should contain_anchor('xldeploy::end')}


  end

  context 'xldeploy class server + housekeeping set to true' do

    let(:params) {{ :server => 'true',
                    :enable_housekeeping => 'true' }}

    it { should contain_class('xldeploy::housekeeping')}
  end



  context 'xldeploy class wit server set to false' do
    let(:params) {{ :server => 'false'}}

    it { should contain_anchor('xldeploy::begin') }
    it { should contain_class('xldeploy::client::user') }
    it { should contain_class('xldeploy::client::config')}
    it { should contain_anchor('xldeploy::end') }
  end

end #describe xldeploy
