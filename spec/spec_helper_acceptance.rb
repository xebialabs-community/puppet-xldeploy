require 'beaker-rspec'
require 'pry'

UNSUPPORTED_PLATFORMS = [ 'Windows', 'Solaris', 'AIX' ]

unless ENV['RS_PROVISION'] == 'no'
  hosts.each do |host|
    # Install Puppet
    if host.is_pe?
      install_pe
    else
      install_package host, 'rubygems'
      on host, 'gem install puppet --no-ri --no-rdoc'
      on host, "mkdir -p #{host['distmoduledir']}"
    end
  end
end

RSpec.configure do |c|
  if RUBY_VERSION =~ /1.9/
    Encoding.default_external = Encoding::UTF_8
    Encoding.default_internal = Encoding::UTF_8
  end
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install modules
    puppet_module_install(:source => proj_root, :module_name => 'deployit')


    hosts.each do |host|
      ['puppetlabs-inifile','puppetlabs-concat','dalen-puppetdbquery','jtopjian-sshkeys'].each do |mod|
        shell("puppet module install #{mod}", { :acceptable_exit_codes => [0,1] })
      end
      shell("puppet module install puppetlabs-stdlib --version=3.2.0", { :acceptable_exit_codes => [0,1] })
    end



  end
end