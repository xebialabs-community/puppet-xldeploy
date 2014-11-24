require 'spec_helper'

describe 'xldeploy::client' do
  let(:facts) {{ :osfamily => 'RedHat' }}

  context 'xldeploy default client class' do
    let(:params) {{ }}

    it { should contain_anchor('xldeploy::client::begin') }
    it { should contain_class('xldeploy::client::user') }
    it { should contain_class('xldeploy::client::gems') }
    it { should contain_class('xldeploy::client::config') }
    it { should contain_anchor('xldeploy::client::end') }
  end

  context 'xldeploy client class' do
    let(:params) {{ 
    	:http_context_root => '/xldeploy',
        :http_server_address => 'xldeploy.test.url',
        :http_port           => '4516',
        :rest_password      => 'dummy',
        :ssl                 => false }}

    it { should contain_anchor('xldeploy::client::begin') }
    it { should contain_class('xldeploy::client::user') }
    it { should contain_class('xldeploy::client::gems') }
    it { should contain_class('xldeploy::client::config') }
    it { should contain_anchor('xldeploy::client::end') }
  end

  context 'xldeploy client class with ssl verified' do
    let(:params) {{ 
    	:http_context_root => '/xldeploy',
        :http_server_address => 'xldeploy.test.url',
        :http_port           => '4516',
        :rest_password      => 'dummy',
        :ssl                 => true }}

    it { should contain_anchor('xldeploy::client::begin') }
    it { should contain_class('xldeploy::client::user') }
    it { should contain_class('xldeploy::client::gems') }
    it { should contain_class('xldeploy::client::config') }
    it { should contain_anchor('xldeploy::client::end') }
  end

  context 'xldeploy client class with ssl not verified' do
    let(:params) {{ 
    	:http_context_root => '/xldeploy',
        :http_server_address => 'xldeploy.test.url',
        :http_port           => '4516',
        :rest_password      => 'dummy',
        :ssl                 => true,
        :verifySsl           => false }}

    it { should contain_anchor('xldeploy::client::begin') }
    it { should contain_class('xldeploy::client::user') }
    it { should contain_class('xldeploy::client::gems') }
    it { should contain_class('xldeploy::client::config') }
    it { should contain_anchor('xldeploy::client::end') }
  end
end #describe xldeploy
