require 'spec_helper'

describe 'deployit::install' do

  let(:facts) {{ :osfamily => 'RedHat',
                 :concat_basedir => '/var/tmp' }}

    context 'with defaults' do
      let(:params) {{ :version                     => '3.9.4',
                      :base_dir                    => '/opt/deployit',
                      :tmp_dir                     => '/var/tmp',
                      :os_user                     => 'deployit',
                      :os_group                    => 'deployit',
                      :install_type                => 'puppetfiles',
                      :server_home_dir             => '/opt/deployit/deployit-server',
                      :cli_home_dir                => '/opt/deployit/deployit-cli',
                      :install_java                => 'false',
                      :java_home                   => '/usr/lib/jvm/jre-1.7.0-openjdk.x86_64',
                      :puppetfiles_deployit_source => 'modules/deployit/sources' }}

      it {should contain_group('deployit').with_ensure('present')}
      it {should contain_user('deployit').with_ensure('present').with_gid('deployit')}
      it {should contain_file('/var/log/deployit').with_ensure('link').with_target('/opt/deployit/deployit-3.9.4-server/log')}
      it {should contain_file('/etc/deployit').with_ensure('link').with_target('/opt/deployit/deployit-3.9.4-server/conf')}
      it {should contain_file('/etc/init.d/deployit').with_owner('root').with_group('root').with_mode('0700')}
      it {should contain_file('/opt/deployit/deployit-server').with_owner('deployit').with_group('deployit').with_ensure('link').with_target('/opt/deployit/deployit-3.9.4-server')}
      it {should contain_file('/opt/deployit/deployit-cli').with_owner('deployit').with_group('deployit').with_ensure('link').with_target('/opt/deployit/deployit-3.9.4-cli')}
      it {should contain_file('/opt/deployit/deployit-server/scripts').with_owner('deployit').with_group('deployit').with_ensure('directory')}

    end

   context 'with install_java set to true' do
     let(:params) {{:version                     => '3.9.4',
                    :base_dir                    => '/opt/deployit',
                    :tmp_dir                     => '/var/tmp',
                    :os_user                     => 'deployit',
                    :os_group                    => 'deployit',
                    :install_type                => 'puppetfiles',
                    :server_home_dir             => '/opt/deployit/deployit-server',
                    :cli_home_dir                => '/opt/deployit/deployit-cli',
                    :install_java                => 'true',
                    :java_home                   => '/usr/lib/jvm/jre-1.7.0-openjdk.x86_64',
                    :puppetfiles_deployit_source => 'modules/deployit/sources'}}

     it {should contain_package('java-1.7.0-openjdk').with_ensure('present')}
   end

  context 'with install_type set to puppetfiles' do
    let(:params) {{:version                     => '3.9.4',
                   :base_dir                    => '/opt/deployit',
                   :tmp_dir                     => '/var/tmp',
                   :os_user                     => 'deployit',
                   :os_group                    => 'deployit',
                   :install_type                => 'puppetfiles',
                   :server_home_dir             => '/opt/deployit/deployit-server',
                   :cli_home_dir                => '/opt/deployit/deployit-cli',
                   :install_java                => 'true',
                   :java_home                   => '/usr/lib/jvm/jre-1.7.0-openjdk.x86_64',
                   :puppetfiles_deployit_source => 'modules/deployit/sources'}}

    it {should contain_file('/var/tmp/deployit-3.9.4-server.zip').with_source('puppet:///modules/deployit/sources/deployit-3.9.4-server.zip')}
    it {should contain_file('/var/tmp/deployit-3.9.4-cli.zip').with_source('puppet:///modules/deployit/sources/deployit-3.9.4-cli.zip')}
    it {should contain_file('/opt/deployit').with_ensure('directory')}
    it {should contain_file('/opt/deployit/deployit-server').with_ensure('link')}
    it {should contain_file('/opt/deployit/deployit-cli').with_ensure('link')}
    it {should contain_exec('unpack server file').with({
                    :command => '/usr/bin/unzip /var/tmp/deployit-3.9.4-server.zip;/bin/cp -rp /var/tmp/deployit-3.9.4-server/* /opt/deployit/deployit-3.9.4-server',
                    :creates => '/opt/deployit/deployit-3.9.4-server/bin',
                    :cwd     => '/var/tmp',
                    :user    => 'deployit'
            }) }
    it {should contain_exec('unpack cli file').with({
                    :command => '/usr/bin/unzip /var/tmp/deployit-3.9.4-cli.zip;/bin/cp -rp /var/tmp/deployit-3.9.4-cli/* /opt/deployit/deployit-3.9.4-cli',
                    :creates => '/opt/deployit/deployit-3.9.4-cli/bin',
                    :cwd     => '/var/tmp',
                    :user    => 'deployit'
            }) }
  end
  context 'with install_type set to packages' do
    let(:params) {{:version                     => '3.9.4',
                   :base_dir                    => '/opt/deployit',
                   :tmp_dir                     => '/var/tmp',
                   :os_user                     => 'deployit',
                   :os_group                    => 'deployit',
                   :install_type                => 'packages',
                   :server_home_dir             => '/opt/deployit/deployit-server',
                   :cli_home_dir                => '/opt/deployit/deployit-cli',
                   :install_java                => 'true',
                   :java_home                   => '/usr/lib/jvm/jre-1.7.0-openjdk.x86_64',
                   :puppetfiles_deployit_source => 'modules/deployit/sources'}}

    it {should contain_package('deployit-server').with_ensure('3.9.4-jep')}
    it {should contain_package('deployit-cli').with_ensure('3.9.4-jep')}
  end
  context 'with install_type set to downloads' do
    let(:params) {{:version                     => '3.9.4',
                   :base_dir                    => '/opt/deployit',
                   :tmp_dir                     => '/var/tmp',
                   :os_user                     => 'deployit',
                   :os_group                    => 'deployit',
                   :install_type                => 'download',
                   :download_user               => 'download',
                   :download_password           => 'download',
                   :server_home_dir             => '/opt/deployit/deployit-server',
                   :download_cli_url            => 'https://tech.xebialabs.com/download/deployit/3.9.4/deployit-3.9.4-cli.zip',
                   :download_server_url         => 'https://tech.xebialabs.com/download/deployit/3.9.4/deployit-3.9.4-server.zip',
                   :cli_home_dir                => '/opt/deployit/deployit-cli',
                   :install_java                => 'true',
                   :java_home                   => '/usr/lib/jvm/jre-1.7.0-openjdk.x86_64',
                   :puppetfiles_deployit_source => 'modules/deployit/sources'}}

    it {should contain_deployit_netinstall('https://tech.xebialabs.com/download/deployit/3.9.4/deployit-3.9.4-server.zip')}
    it {should contain_deployit_netinstall('https://tech.xebialabs.com/download/deployit/3.9.4/deployit-3.9.4-cli.zip')}
  end
  context 'with install_license set to true and puppet file given' do
    let(:params) {{:version                     => '3.9.4',
                   :base_dir                    => '/opt/deployit',
                   :tmp_dir                     => '/var/tmp',
                   :os_user                     => 'deployit',
                   :os_group                    => 'deployit',
                   :install_type                => 'download',
                   :download_user               => 'download',
                   :download_password           => 'download',
                   :server_home_dir             => '/opt/deployit/deployit-server',
                   :download_cli_url            => 'https://tech.xebialabs.com/download/deployit/3.9.4/deployit-3.9.4-cli.zip',
                   :download_server_url         => 'https://tech.xebialabs.com/download/deployit/3.9.4/deployit-3.9.4-server.zip',
                   :cli_home_dir                => '/opt/deployit/deployit-cli',
                   :install_java                => 'true',
                   :java_home                   => '/usr/lib/jvm/jre-1.7.0-openjdk.x86_64',
                   :puppetfiles_deployit_source => 'modules/deployit/sources',
                   :install_license             => 'true',
                   :license_source              => 'puppet:///modules/deployit/file/deployit-license.lic'}}

    it {should contain_file('/opt/deployit/deployit-server/conf/deployit-license.lic').with_source('puppet:///modules/deployit/file/deployit-license.lic')}
  end
  context 'with install_license set to true and url given' do
    let(:params) {{:version                     => '3.9.4',
                   :base_dir                    => '/opt/deployit',
                   :tmp_dir                     => '/var/tmp',
                   :os_user                     => 'deployit',
                   :os_group                    => 'deployit',
                   :install_type                => 'download',
                   :download_user               => 'download',
                   :download_password           => 'download',
                   :server_home_dir             => '/opt/deployit/deployit-server',
                   :download_cli_url            => 'https://tech.xebialabs.com/download/deployit/3.9.4/deployit-3.9.4-cli.zip',
                   :download_server_url         => 'https://tech.xebialabs.com/download/deployit/3.9.4/deployit-3.9.4-server.zip',
                   :cli_home_dir                => '/opt/deployit/deployit-cli',
                   :install_java                => 'true',
                   :java_home                   => '/usr/lib/jvm/jre-1.7.0-openjdk.x86_64',
                   :puppetfiles_deployit_source => 'modules/deployit/sources',
                   :install_license             => 'true',
                   :license_source              => 'https://tech.xebialabs.com/download/licenses/download/deployit-license.lic'}}

    it {should contain_deployit_license_install('https://tech.xebialabs.com/download/licenses/download/deployit-license.lic').with_destinationdirectory('/opt/deployit/deployit-server/conf')}
  end

end


