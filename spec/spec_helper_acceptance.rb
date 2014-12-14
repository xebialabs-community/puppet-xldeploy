require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'pry'




class String
  # Provide ability to remove indentation from strings, for the purpose of
  # left justifying heredoc blocks.
  def unindent
    gsub(/^#{scan(/^\s*/).min_by{|l|l.length}}/, "")
  end
end

def shellescape(str)
  str = str.to_s

  # An empty argument will be skipped, so return empty quotes.
  return "''" if str.empty?

  str = str.dup

  # Treat multibyte characters as is.  It is caller's responsibility
  # to encode the string in the right encoding for the shell
  # environment.
  str.gsub!(/([^A-Za-z0-9_\-.,:\/@\n])/, "\\\\\\1")

  # A LF cannot be escaped with a backslash because a backslash + LF
  # combo is regarded as line continuation and simply ignored.
  str.gsub!(/\n/, "'\n'")

  return str
end


unless ENV['RS_PROVISION'] == 'no' or ENV['BEAKER_provision'] == 'no'
  if hosts.first.is_pe?
    install_pe
  else
    install_puppet
  end
  hosts.each do |host|
    shell("mkdir -p #{host['distmoduledir']}")
    if ! host.is_pe?
      # Augeas is only used in one place, for Redhat.
      if fact('osfamily') == 'RedHat'
        install_package host, 'ruby-devel'
        install_package host, 'augeas-devel'
        install_package host, 'ruby-augeas'
      end
    end
  end
end

UNSUPPORTED_PLATFORMS = ['AIX','windows','Solaris','Suse']

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do

    # setup master
    on master, "echo '*' > /etc/puppet/autosign.conf"
    master_name = "#{master}.test.local"
    config = {
        'main' => {
            'server'   => master_name,
            'certname' => master_name,
            'logdir'   => '/var/log/puppet',
            'vardir'   => '/var/lib/puppet',
            'ssldir'   => '/var/lib/puppet/ssl',
            'rundir'   => '/var/run/puppet'
        },
        'agent' => {
            'environment' => 'vagrant'
        }
    }

    configure_puppet(master, config)

    on master, "/etc/init.d/puppetmaster restart"

    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'xldeploy')

    hosts.each do |host|
      on host, "/bin/touch #{default['puppetpath']}/hiera.yaml"
      on host, "/bin/mkdir -p #{default['puppetpath']}/manifests"
      on host, 'chmod 755 /root'
      if fact('osfamily') == 'Debian'
        on host, "echo \"en_US ISO-8859-1\nen_NG.UTF-8 UTF-8\nen_US.UTF-8 UTF-8\n\" > /etc/locale.gen"
        on host, '/usr/sbin/locale-gen'
        on host, '/usr/sbin/update-locale'
        on host, shell('apt-get -y install rubygems')
      end
      if fact('osfamily') == 'RedHat'
        shell('yum -y install policycoreutils-python')
      end

      if RUBY_VERSION =~ /2/
        Encoding.default_external = Encoding::UTF_8
        Encoding.default_internal = Encoding::UTF_8
      end

      on host, puppet('module','install','puppetlabs-concat'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','puppetlabs-inifile'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','dalen-puppetdbquery'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module','install','jtopjian-sshkeys'), { :acceptable_exit_codes => [0,1] }

    end
  end
end
