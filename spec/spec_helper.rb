require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'hiera'
require 'puppet'
require 'puppet_x/xebialabs/xldeploy/cli.rb'


RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

end

class PuppetXLDeployModule

end

def run_puppet_command_with_file(filename)
  `puppet apply --modulepath .. tests/#{filename}  --trace`
end


