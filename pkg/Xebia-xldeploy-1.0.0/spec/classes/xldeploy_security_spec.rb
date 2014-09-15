require 'spec_helper'

describe 'xldeploy::security' do
  let(:facts) { {:osfamily       => 'RedHat',
                 :concat_basedir => '/var/tmp'} }

  context 'without ldap' do
    let(:params){{
        :server_home_dir => '/opt/deployit/deployit-server',
        :os_user         => 'deployit',
        :os_group        => 'deployit',
    }}

    it {should contain_concat('/opt/deployit/deployit-server/conf/deployit-security.xml')}
    it {should contain_concat__fragment('security_header').with_target('/opt/deployit/deployit-server/conf/deployit-security.xml')}
    it {should contain_concat__fragment('security_footer').with_target('/opt/deployit/deployit-server/conf/deployit-security.xml')}
    it {should contain_concat__fragment('security_authentication_manager').with_target('/opt/deployit/deployit-server/conf/deployit-security.xml')}
    it {should_not contain_concat__fragment('security_beans')}
    it {should_not contain_concat__fragment('security_ldapserver')}

    end

  context 'with ldap_server_id set to test' do
    let(:params){{
        :server_home_dir => '/opt/deployit/deployit-server',
        :os_user         => 'deployit',
        :os_group        => 'deployit',
        :ldap_server_id  => 'test'
    }}

    it {should contain_concat('/opt/deployit/deployit-server/conf/deployit-security.xml')}
    it {should contain_concat__fragment('security_header').with_target('/opt/deployit/deployit-server/conf/deployit-security.xml')}
    it {should contain_concat__fragment('security_footer').with_target('/opt/deployit/deployit-server/conf/deployit-security.xml')}
    it {should contain_concat__fragment('security_authentication_manager').with_target('/opt/deployit/deployit-server/conf/deployit-security.xml')}
    it {should_not contain_concat__fragment('security_beans')}
    it {should contain_concat__fragment('security_ldapserver')}

  end

  context 'with xldeploy_authentication_providers set to some hash' do
    let(:params){{
        :server_home_dir => '/opt/deployit/deployit-server',
        :os_user         => 'deployit',
        :os_group        => 'deployit',
        :xldeploy_authentication_providers => {'rememberMeAuthenticationProvider' => 'com.xebialabs.deployit.security.authentication.RememberMeAuthenticationProvider',
                                               'jcrAuthenticationProvider' => 'com.xebialabs.deployit.security.authentication.JcrAuthenticationProvider'}
    }}

    it {should contain_concat('/opt/deployit/deployit-server/conf/deployit-security.xml')}
    it {should contain_concat__fragment('security_header').with_target('/opt/deployit/deployit-server/conf/deployit-security.xml')}
    it {should contain_concat__fragment('security_footer').with_target('/opt/deployit/deployit-server/conf/deployit-security.xml')}
    it {should contain_concat__fragment('security_authentication_manager').with_target('/opt/deployit/deployit-server/conf/deployit-security.xml')}
    it {should contain_concat__fragment('security_beans')}
    it {should_not contain_concat__fragment('security_ldapserver')}

  end
end


