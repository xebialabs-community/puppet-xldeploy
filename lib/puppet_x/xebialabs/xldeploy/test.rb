#!/opt/puppet/bin/ruby
require 'pp'
require File.join(File.dirname(__FILE__), 'ci')
require File.join(File.dirname(__FILE__), 'password')
require File.join(File.dirname(__FILE__), 'dictionary_entry')
require File.join(File.dirname(__FILE__), 'user')


rest_url = 'http://admin:admin@localhost:4516/deployit/deployit'

#id = 'Infrastructure/ZMM/test/test/xh1'
#type = 'overthere.SshHost'
#properties = {"address"=>"10.20.1.3", "connectionType"=>"SUDO", "os"=>"UNIX", "port"=>"22", "username"=>"xldeploy", "sudoUsername"=>"root", "temporaryDirectoryPath"=>"/var/tmp", "tags"=>""}

#id = 'Infrastructure/ZMM/test2'
#type = 'core.Directory'
#properties = {}


# ci = Ci.new(rest_url, id, type, properties)

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
#
#
# p ci.update_needed?
# p ci.update_needed?(strict = true)
# p ci.run_discovery

#password = Password.new(rest_url, "test")
#p password.translated

entry = Dictionary_entry.new(rest_url,'Environments/test/test1', 'blablabla')
entry2 = Dictionary_entry.new(rest_url,'Environments/test/test2', 'blablabla2')

# p entry.dictionary_content
# p entry.key
# p entry.value
#  entry.dictionary
#  p entry.dictionary_exists?
#   p entry.key_exists?
#   p entry.value_correct?
#  p entry.persist
#  p entry2.persist

user1 = User.new(rest_url, 'wianvos', 'testtest')
user1.to_xml
user1.create
p user1.exists?
user1.destroy
p user1.exists?