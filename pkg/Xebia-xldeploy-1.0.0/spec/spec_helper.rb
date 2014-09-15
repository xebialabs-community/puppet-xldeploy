require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'
require 'hiera'

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

end

