require 'spec_helper'

describe 'xldeploy::server' do

  shared_examples 'a Linux Os' do

    context 'basic usage' do

        describe "xldeploy class without any parameters" do

          let(:params) {{ }}

          it { should contain_class('xldeploy::params') }
          it { should contain_class('xldeploy::server::validation') }
          it { should contain_anchor('xldeploy::server::begin') }
          it { should contain_class('xldeploy::server::install') }
          it { should contain_class('xldeploy::server::config')}
          it { should contain_class('xldeploy::server::security')}
          it { should contain_class('xldeploy::server::service')}
          it { should contain_class('xldeploy::server::post_config')}
          it { should contain_anchor('xldeploy::server::end')}

        end
    end


    context 'xldeploy class server + housekeeping set to true' do

      let(:params) {{ :enable_housekeeping => 'true' }}

      it { should contain_class('xldeploy::server::housekeeping')}
    end

    context 'xldeploy with version set to 3.9.4' do

      let(:params) {{ :version => '3.9.4' }}

      it { should contain_file('log dir link').with_ensure('link').with_target('/opt/deployit/deployit-3.9.4-server/log')}
      it { should contain_file('conf dir link').with_ensure('link').with_target('/opt/deployit/deployit-3.9.4-server/conf')}
      it { should contain_file('/etc/init.d/deployit').with_owner('root').with_group('root').with_mode('0700')}
      it { should contain_file('/opt/deployit/deployit-server').with_owner('deployit').with_group('deployit').with_ensure('link').with_target('/opt/deployit/deployit-3.9.4-server')}
      it { should contain_file('/opt/deployit/deployit-server/scripts').with_owner('deployit').with_group('deployit').with_ensure('directory')}
      it { should contain_xldeploy_netinstall('https://tech.xebialabs.com/download/deployit/3.9.4/deployit-3.9.4-server.zip')}
      it { should contain_file('/opt/deployit/deployit-server/conf/deployit.conf').with({:ensure => 'present',:owner =>'deployit',:group =>'deployit',:mode => '0640',:ignore => '.gitkeep'}) }
      it { should contain_file('xldeploy server plugins').with({:ensure => 'present',:owner =>'deployit',:group =>'deployit',:mode=>'0640',:ignore=>'.gitkeep',:recurse=>'true',:sourceselect=>'all',:source=>['puppet:///modules/xldeploy/plugins/generic','puppet:///modules/xldeploy/plugins/customer',"/opt/deployit/deployit-server/available-plugins"]})}
      it { should contain_file('xldeploy server hotfix').with({:ensure=>'present',:owner=>'deployit',:group=>'deployit',:mode=>'0640',:ignore=>'.gitkeep',:recurse=>'true',:purge=>'true',:source=>['puppet:///modules/xldeploy/hotfix/'],:path=>'/opt/deployit/deployit-server/hotfix'})}
      it { should contain_file('xldeploy server ext').with({:ensure=>'present',:owner=>'deployit',:group=>'deployit',:mode=>'0640',:ignore=>'.gitkeep',:recurse=>'remote',:source=>['puppet:///modules/xldeploy/server-ext/'],:path=>'/opt/deployit/deployit-server/ext'})}
      it { should contain_file('xldeploy cli ext').with({:ensure=>'present',:owner=>'deployit',:group=>'deployit',:mode=>'0640',:ignore=>'.gitkeep',:recurse=>'remote',:source=>['puppet:///modules/xldeploy/cli-ext/'],:path=>'/opt/deployit/deployit-cli/ext'})}
      it { should contain_ini_setting('xldeploy.admin.password').with({:ensure=>'present',:path=>'/opt/deployit/deployit-server/conf/deployit.conf',:section=>'',:setting=>'admin.password',:value=>'admin'})}
      it { should contain_ini_setting('xldeploy.http.port').with({:ensure=>'present',:path=>'/opt/deployit/deployit-server/conf/deployit.conf',:section=>'',:setting=>'http.port',:value=>'4516'})}
      it { should contain_ini_setting('xldeploy.jcr.repository.path').with({:ensure=>'present',:path=>'/opt/deployit/deployit-server/conf/deployit.conf',:section=>'',:setting=>'jcr.repository.path',:value=>'repository'})}
      it { should contain_ini_setting('xldeploy.ssl').with({:ensure=>'present',:path=>'/opt/deployit/deployit-server/conf/deployit.conf',:section=>'',:setting=>'ssl',:value=>'false'})}
      it { should contain_ini_setting('xldeploy.http.bind.address').with({:ensure=>'present',:path=>'/opt/deployit/deployit-server/conf/deployit.conf',:section=>'',:setting=>'http.bind.address',:value=>'0.0.0.0'})}
      it { should contain_ini_setting('xldeploy.http.context.root').with({:ensure=>'present',:path=>'/opt/deployit/deployit-server/conf/deployit.conf',:section=>'',:setting=>'http.context.root',:value=>'/deployit'})}
      it { should contain_ini_setting('xldeploy.importable.packages.path').with({:ensure=>'present',:path=>'/opt/deployit/deployit-server/conf/deployit.conf',:section=>'',:setting=>'importable.packages.path',:value=>'importablePackages'})}
      it { should contain_exec('init xldeploy').with({:creates=>"/opt/deployit/deployit-server/repository",:command=>"/opt/deployit/deployit-server/bin/server.sh -setup -reinitialize -force -setup-defaults /opt/deployit/deployit-server/conf/deployit.conf",:user=>'deployit'})}
      it { should contain_sshkeys__create_key('deployit').with_home('/opt/deployit/deployit-server').with_manage_home('false')}
      it { should contain_xldeploy__resources__defaultsetting('overthere.SshHost.passphrase')}
      it { should contain_xldeploy__resources__defaultsetting('overthere.SshHost.privateKeyFile').with_value('/opt/deployit/deployit-server/.ssh/id_rsa')}
      it { should contain_service('deployit').with_ensure('running')}
      it { should contain_concat('/opt/deployit/deployit-server/conf/deployit-security.xml')}
      it { should contain_concat__fragment('security_header').with_target('/opt/deployit/deployit-server/conf/deployit-security.xml')}
      it { should contain_concat__fragment('security_footer').with_target('/opt/deployit/deployit-server/conf/deployit-security.xml')}
      it { should contain_concat__fragment('security_authentication_manager').with_target('/opt/deployit/deployit-server/conf/deployit-security.xml')}
      it { should contain_concat__fragment('security_beans')}
      it { should_not contain_concat__fragment('security_ldapserver')}

    end

    context 'xldeploy with version set to 4.5.0' do

      let(:params) {{ :version => '4.5.0' }}

      it { should contain_file('log dir link').with_ensure('link').with_target('/opt/xl-deploy/xl-deploy-4.5.0-server/log')}
      it { should contain_file('conf dir link').with_ensure('link').with_target('/opt/xl-deploy/xl-deploy-4.5.0-server/conf')}
      it { should contain_file('/etc/init.d/xl-deploy').with_owner('root').with_group('root').with_mode('0700')}
      it { should contain_file('/opt/xl-deploy/xl-deploy-server').with_owner('xldeploy').with_group('xldeploy').with_ensure('link').with_target('/opt/xl-deploy/xl-deploy-4.5.0-server')}
      it { should contain_file('/opt/xl-deploy/xl-deploy-server/scripts').with_owner('xldeploy').with_group('xldeploy').with_ensure('directory')}
      it { should contain_xldeploy_netinstall('https://tech.xebialabs.com/download/xl-deploy/4.5.0/xl-deploy-4.5.0-server.zip')}
      it { should contain_file('/opt/xl-deploy/xl-deploy-server/conf/deployit.conf').with({:ensure => 'present',:owner => 'xldeploy',:group => 'xldeploy',:mode => '0640',:ignore => '.gitkeep'}) }
      it { should contain_file('xldeploy server plugins').with({:ensure => 'present',:owner => 'xldeploy',:group => 'xldeploy',:mode=>'0640',:ignore=>'.gitkeep',:recurse=>'true',:sourceselect=>'all',:source=>['puppet:///modules/xldeploy/plugins/generic','puppet:///modules/xldeploy/plugins/customer',"/opt/xl-deploy/xl-deploy-server/available-plugins"]})}
      it { should contain_file('xldeploy server hotfix').with({:ensure=>'present',:owner=>'xldeploy',:group=>'xldeploy',:mode=>'0640',:ignore=>'.gitkeep',:recurse=>'true',:purge=>'true',:source=>['puppet:///modules/xldeploy/hotfix/'],:path=>'/opt/xl-deploy/xl-deploy-server/hotfix'})}
      it { should contain_file('xldeploy server ext').with({:ensure=>'present',:owner=>'xldeploy',:group=>'xldeploy',:mode=>'0640',:ignore=>'.gitkeep',:recurse=>'remote',:source=>['puppet:///modules/xldeploy/server-ext/'],:path=>'/opt/xl-deploy/xl-deploy-server/ext'})}
      it { should contain_file('xldeploy cli ext').with({:ensure=>'present',:owner=>'xldeploy',:group=>'xldeploy',:mode=>'0640',:ignore=>'.gitkeep',:recurse=>'remote',:source=>['puppet:///modules/xldeploy/cli-ext/'],:path=>'/opt/xl-deploy/xl-deploy-cli/ext'})}
      it { should contain_ini_setting('xldeploy.admin.password').with({:ensure=>'present',:path=>'/opt/xl-deploy/xl-deploy-server/conf/deployit.conf',:section=>'',:setting=>'admin.password',:value=>'admin'})}
      it { should contain_ini_setting('xldeploy.http.port').with({:ensure=>'present',:path=>'/opt/xl-deploy/xl-deploy-server/conf/deployit.conf',:section=>'',:setting=>'http.port',:value=>'4516'})}
      it { should contain_ini_setting('xldeploy.jcr.repository.path').with({:ensure=>'present',:path=>'/opt/xl-deploy/xl-deploy-server/conf/deployit.conf',:section=>'',:setting=>'jcr.repository.path',:value=>'repository'})}
      it { should contain_ini_setting('xldeploy.ssl').with({:ensure=>'present',:path=>'/opt/xl-deploy/xl-deploy-server/conf/deployit.conf',:section=>'',:setting=>'ssl',:value=>'false'})}
      it { should contain_ini_setting('xldeploy.http.bind.address').with({:ensure=>'present',:path=>'/opt/xl-deploy/xl-deploy-server/conf/deployit.conf',:section=>'',:setting=>'http.bind.address',:value=>'0.0.0.0'})}
      it { should contain_ini_setting('xldeploy.http.context.root').with({:ensure=>'present',:path=>'/opt/xl-deploy/xl-deploy-server/conf/deployit.conf',:section=>'',:setting=>'http.context.root',:value=>'/deployit'})}
      it { should contain_ini_setting('xldeploy.importable.packages.path').with({:ensure=>'present',:path=>'/opt/xl-deploy/xl-deploy-server/conf/deployit.conf',:section=>'',:setting=>'importable.packages.path',:value=>'importablePackages'})}
      it { should contain_exec('init xldeploy').with({:creates=>"/opt/xl-deploy/xl-deploy-server/repository",:command=>"/opt/xl-deploy/xl-deploy-server/bin/server.sh -setup -reinitialize -force -setup-defaults /opt/xl-deploy/xl-deploy-server/conf/deployit.conf",:user=>'xldeploy'})}
      it { should contain_sshkeys__create_key('xldeploy').with_home('/opt/xl-deploy/xl-deploy-server').with_manage_home('false')}
      it { should contain_xldeploy__resources__defaultsetting('overthere.SshHost.passphrase')}
      it { should contain_xldeploy__resources__defaultsetting('overthere.SshHost.privateKeyFile').with_value('/opt/xl-deploy/xl-deploy-server/.ssh/id_rsa')}
      it { should contain_service('xl-deploy').with_ensure('running')}
      it { should contain_concat('/opt/xl-deploy/xl-deploy-server/conf/deployit-security.xml')}
      it { should contain_concat__fragment('security_header').with_target('/opt/xl-deploy/xl-deploy-server/conf/deployit-security.xml')}
      it { should contain_concat__fragment('security_footer').with_target('/opt/xl-deploy/xl-deploy-server/conf/deployit-security.xml')}
      it { should contain_concat__fragment('security_authentication_manager').with_target('/opt/xl-deploy/xl-deploy-server/conf/deployit-security.xml')}
      it { should contain_concat__fragment('security_beans')}
      it { should_not contain_concat__fragment('security_ldapserver')}
    end
 end

  context "Debian OS" do
    let :facts do
      {
          :operatingsystem => 'Debian',
          :osfamily        => 'Debian',
          :lsbdistcodename => 'precise',
          :lsbdistid       => 'Debian',
          :concat_basedir  => '/var/tmp'
      }
    end
    it_behaves_like "a Linux Os" do

    end

  end

  context "RedHat OS with xldeploy 3.9.x" do
    let :facts do
      {
          :operatingsystem => 'RedHat',
          :osfamily        => 'RedHat',
          :concat_basedir  => '/var/tmp'
      }
    end
    it_behaves_like "a Linux Os" do

    end

  end



end
