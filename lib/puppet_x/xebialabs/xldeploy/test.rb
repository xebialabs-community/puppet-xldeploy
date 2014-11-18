#!/opt/puppet/bin/ruby
require 'pp'
require File.join(File.dirname(__FILE__), 'ci')

rest_url = 'http://admin:admin@localhost:4516/deployit/deployit'

id = 'Infrastructure/ZMM/test/test/xh1'
type = 'overthere.SshHost'
properties = {"address"=>"10.20.1.3", "connectionType"=>"SUDO", "os"=>"UNIX", "port"=>"22", "username"=>"xldeploy", "sudoUsername"=>"root", "temporaryDirectoryPath"=>"/var/tmp", "tags"=>""}

#id = 'Infrastructure/ZMM/test2'
#type = 'core.Directory'
#properties = {}

ci = Ci.new(rest_url, id, type, properties)

# p "actual_properties"
# pp ci.actual_properties
#
# p "type description"
# pp ci.type_description

# pp ci.desired_properties
#
# p "desired_xml !!!!"
#
# pp ci.desired_xml
#
# p "persist"
# ci.persist


p ci.update_needed?
p ci.update_needed?(strict = true)
p ci.run_discovery