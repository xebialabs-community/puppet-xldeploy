require 'puppet'
require 'rubygems'
require 'xmlsimple'
require 'rest_client'
require 'pathname'
require 'puppet/type/xldeploy_ci'

RSpec.configure {|config| config.mock_with :mocha }

describe 'The rest provider for the xldeploy_ci type' do
  id   = 'Infrastructure/TestHost'
  parent = 'Infrastructure'
  rest_url = "http://localhost:4516/deployit"
  type = 'overthere.SshHost'
  properties = {'host' => 'testhost', 'os' => 'UNIX', 'connectiontype' => 'SUDO', 'address' => '10.20.1.3', 'port' => '22', 'username' => 'xldeploy'}

  xml_response = '<overthere.SshHost id="Infrastructure/TestHost" token="760cfcf9-7988-4345-9045-e0d8ddda0679">
                  <tags />
                  <os>UNIX</os>
                  <connectionType>SUDO</connectionType>
                  <address>10.20.1.3</address>
                  <port>22</port>
                  <username>xldeploy</username>
                 </overthere.SshHost>'

  xml_invalid_response = '<overthere.SshHost id="Infrastructure/TestHost" token="760cfcf9-7988-4345-9045-e0d8ddda0679">
                          <tags />
                          <os>UNIX</os>
                          <connectionType>SUDO</connectionType>
                          <address>10.20.1.4</address>
                          <port>22</port>
                          <username>xldeploy</username>
                         </overthere.SshHost>'

  xml_true_response = '<boolean>true</boolean>'
  xml_false_response = '<boolean>false</boolean>'

  exists_url = 'repository/exists/Infrastructure/TestHost'
  exists_parent_url = 'repository/exists/Infrastructure'
  create_url = 'repository/ci/Infrastructure/TestHost'
  inspection_prepare_url = 'http://localhost:4516/xldeploy/inspection/prepare'
  inspection_url = 'http://localhost:4516/xldeploy/inspection'

  let (:resource) { Puppet::Type::Xldeploy_ci.new({:id          => id,
                                                   :rest_url    => rest_url,
                                                   :type        => type,
                                                   :properties  => properties }) }

  let (:provider) { Puppet::Type.type(:xldeploy_ci).provider(:rest).new(resource) }



  it 'exists? should return true if repo exists' do
    provider.stubs(:execute_rest).with(exists_url,
                                'get').returns(xml_true_response)
    provider.exists?.should == true
  end
  it 'exists? should return false if repo doesnt exist' do
    provider.stubs(:execute_rest).with(exists_url,
                                       'get').returns(xml_false_response)
    provider.exists?.should == false
  end

  it 'create should try to determine if the parent ci for this ci exists' do
    xml_post = provider.to_xml(id, type, properties)
    provider.expects(:execute_rest).with(exists_parent_url, 'get').returns(xml_true_response)
    provider.expects(:execute_rest).with(create_url, 'post', xml_post).returns(xml_response)
    provider.create
  end
#
# =begin
#   it 'create with discovey set to true should try do run a discovery job on the xldeploy server' do
#
#     resource[:discovery] = true
#     xml_post = provider.to_xml(id, type, properties)
#     RestClient.expects(:post).with(inspection_prepare_url, :content_type => :xml).returns
#     RestClient.expects(:get).with(exists_parent_url,
#                                   :accept => :xml,
#                                   :content_type => :xml ).returns(xml_true_response)
#     RestClient.expects(:post).with(create_url, xml_post, :content_type => :xml).returns(xml_response)
#     provider.create
#   end
# =end
#   it 'destroy should try to destroy the ci ' do
#     xml_post = provider.to_xml(id, type, properties)
#     RestClient.expects(:delete).with(create_url,
#                                      :accept => :xml,
#                                      :content_type => :xml ).returns(xml_true_response)
#     provider.destroy
#   end
#
#   it 'should return the actual properties wich should not be equal to the properties given' do
#     RestClient.expects(:get).with(create_url, :accept => :xml, :content_type => :xml).returns(xml_invalid_response)
#     provider.properties != properties
#   end
#
#   it 'should pass the correct xml to rest put when properties need amending' do
#     xml_put = provider.to_xml(id, type, properties)
#     RestClient.expects(:put).with(create_url, xml_put, :content_type => :xml).returns(xml_response)
#     provider.properties= properties
#   end
end