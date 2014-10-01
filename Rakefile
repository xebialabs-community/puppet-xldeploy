require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.fail_on_warnings
PuppetLint.configuration.send('disable_80chars')

desc "Run integration specs"
RSpec::Core::RakeTask.new('spec:integration') do |t|
  t.pattern = 'spec/integration/*_spec.rb'
end


PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_class_parameter_defaults')
PuppetLint.configuration.send('disable_documentation')
PuppetLint.configuration.send('disable_single_quote_string_with_variables')
PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp"]


desc "Run integration specs"
RSpec::Core::RakeTask.new('spec:integration') do |t|
  t.pattern = 'spec/integration/*_spec.rb'
end

task :default => [:spec, :lint]
