require 'spec_helper'

describe 'xldeploy::config' do

  context 'with default parameters' do
    let(:facts) { {:osfamily => 'RedHat',
                   :concat_basedir => '/var/tmp'} }

    let(:params) { {
        :version => '4.0.1',
        :base_dir => '/opt/xldeploy',
        :os_user => 'xldeploy',
        :os_group => 'xldeploy',
        :ssl => false,
        :http_bind_address => '192.168.0.1',
        :http_port => '4516',
        :http_context_root => '/xldeploy',
        :admin_password => 'admin',
        :jcr_repository_path => 'repository',
        :importable_packages_path => 'importablePackages',
        :java_home => '/usr/lib/jvm/jre-1.6.0-openjdk.x86_64',
        :rest_url => 'http://localhost:4516/xldeploy',
        :xldeploy_default_settings => {}
    } }
    it { should contain_file('/opt/xldeploy/xldeploy-4.0.1-server/conf/deployit.conf').with({
                                                                                                :ensure => 'present',
                                                                                                :owner => 'xldeploy',
                                                                                                :group => 'xldeploy',
                                                                                                :mode => '0640',
                                                                                                :ignore => '.gitkeep'
                                                                                            }) }
    it { should contain_file('xldeploy server plugins').with({
                                                                 :ensure => 'present',
                                                                 :owner => 'xldeploy',
                                                                 :group => 'xldeploy',
                                                                 :mode => '0640',
                                                                 :ignore => '.gitkeep',
                                                                 :recurse => 'true',
                                                                 :sourceselect => 'all',
                                                                 :source => ['puppet:///modules/xldeploy/plugins/generic', 'puppet:///modules/xldeploy/plugins/customer', "/opt/xldeploy/xldeploy-4.0.1-server/available-plugins"]
                                                             }) }
    it { should contain_file('xldeploy server hotfix').with({
                                                                :ensure => 'present',
                                                                :owner => 'xldeploy',
                                                                :group => 'xldeploy',
                                                                :mode => '0640',
                                                                :ignore => '.gitkeep',
                                                                :recurse => 'true',
                                                                :purge => 'true',
                                                                :source => ['puppet:///modules/xldeploy/hotfix/'],
                                                                :path => '/opt/xldeploy/xldeploy-4.0.1-server/hotfix'
                                                            }) }
    it { should contain_file('xldeploy server ext').with({
                                                             :ensure => 'present',
                                                             :owner => 'xldeploy',
                                                             :group => 'xldeploy',
                                                             :mode => '0640',
                                                             :ignore => '.gitkeep',
                                                             :recurse => 'remote',
                                                             :source => ['puppet:///modules/xldeploy/server-ext/'],
                                                             :path => '/opt/xldeploy/xldeploy-4.0.1-server/ext'
                                                         }) }


    it { should contain_file('xldeploy cli ext').with({
                                                          :ensure => 'present',
                                                          :owner => 'xldeploy',
                                                          :group => 'xldeploy',
                                                          :mode => '0640',
                                                          :ignore => '.gitkeep',
                                                          :recurse => 'remote',
                                                          :source => ['puppet:///modules/xldeploy/cli-ext/'],
                                                          :path => '/opt/xldeploy/xldeploy-4.0.1-cli/ext'
                                                      }) }

    it { should contain_ini_setting('xldeploy.admin.password').with({
                                                                        :ensure => 'present',
                                                                        :path => '/opt/xldeploy/xldeploy-4.0.1-server/conf/xldeploy.conf',
                                                                        :section => '',
                                                                        :setting => 'admin.password',
                                                                        :value => 'admin'
                                                                    }) }
    it { should contain_ini_setting('xldeploy.http.port').with({
                                                                   :ensure => 'present',
                                                                   :path => '/opt/xldeploy/xldeploy-4.0.1-server/conf/xldeploy.conf',
                                                                   :section => '',
                                                                   :setting => 'http.port',
                                                                   :value => '4516'
                                                               }) }
    it { should contain_ini_setting('xldeploy.jcr.repository.path').with({
                                                                             :ensure => 'present',
                                                                             :path => '/opt/xldeploy/xldeploy-4.0.1-server/conf/xldeploy.conf',
                                                                             :section => '',
                                                                             :setting => 'jcr.repository.path',
                                                                             :value => 'repository'
                                                                         }) }
    it { should contain_ini_setting('xldeploy.ssl').with({
                                                             :ensure => 'present',
                                                             :path => '/opt/xldeploy/xldeploy-4.0.1-server/conf/xldeploy.conf',
                                                             :section => '',
                                                             :setting => 'ssl',
                                                             :value => 'false'
                                                         }) }
    it { should contain_ini_setting('xldeploy.http.bind.address').with({
                                                                           :ensure => 'present',
                                                                           :path => '/opt/xldeploy/xldeploy-4.0.1-server/conf/xldeploy.conf',
                                                                           :section => '',
                                                                           :setting => 'http.bind.address',
                                                                           :value => '192.168.0.1'
                                                                       }) }
    it { should contain_ini_setting('xldeploy.http.context.root').with({
                                                                           :ensure => 'present',
                                                                           :path => '/opt/xldeploy/xldeploy-4.0.1-server/conf/xldeploy.conf',
                                                                           :section => '',
                                                                           :setting => 'http.context.root',
                                                                           :value => '/xldeploy'
                                                                       }) }
    it { should contain_ini_setting('xldeploy.importable.packages.path').with({
                                                                                  :ensure => 'present',
                                                                                  :path => '/opt/xldeploy/xldeploy-4.0.1-server/conf/deployit.conf',
                                                                                  :section => '',
                                                                                  :setting => 'importable.packages.path',
                                                                                  :value => 'importablePackages'
                                                                              }) }
    it { should contain_exec('init xldeploy').with({
                                                       :creates => "/opt/xldeploy/xldeploy-4.0.1-server/repository",
                                                       :command => "/opt/xldeploy/xldeploy-4.0.1-server/bin/server.sh -setup -reinitialize -force -setup-defaults /opt/xldeploy/xldeploy-4.0.1-server/conf/deployit.conf",
                                                       :user => 'xldeploy',
                                                       :environment => ["JAVA_HOME=/usr/lib/jvm/jre-1.6.0-openjdk.x86_64"]
                                                   }) }
  end

  context "with xldeploy_default_settings containing valid settings" do
    let (:params) { {
        :version => '4.0.1',
        :base_dir => '/opt/xldeploy',
        :os_user => 'xldeploy',
        :os_group => 'xldeploy',
        :ssl => false,
        :http_bind_address => '192.168.0.1',
        :http_port => '4516',
        :http_context_root => '/xldeploy',
        :admin_password => 'admin',
        :jcr_repository_path => 'repository',
        :importable_packages_path => 'importablePackages',
        :java_home => '/usr/lib/jvm/jre-1.6.0-openjdk.x86_64',
        :rest_url => 'http://localhost:4516/xldeploy',
        :xldeploy_default_settings => {'test.test' => {'value' => 'test'}}
    } }

    it { should contain_xldeploy__resources__defaultsetting('test.test').with({
                                                           :value => 'test',
                                                           :key => 'test.test',
                                                           :ensure => 'present'
                                                       }) }
  end

end

