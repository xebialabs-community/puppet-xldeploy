require 'puppet'
require 'pathname'
require 'puppet/type/xldeploy_check_connection'

describe Puppet::Type.type(:xldeploy_check_connection) do
  subject { Puppet::Type.type(:xldeploy_check_connection).new(:name => 'default')}

  it 'should be ensurable' do
    subject[:ensure] = :present
    subject[:ensure].should == :present
    subject[:ensure] = :absent
    subject[:ensure].should == :absent
  end

  it 'should accept a rest_url' do
    subject[:rest_url] = "http://admin:admin@localhost:4516/deployit"
    subject[:rest_url].should == "http://admin:admin@localhost:4516/deployit"
  end


  it 'should run when timeout gets passed an integer or a integer masked as a string' do
    subject[:timeout] = 40
    subject[:timeout].should == 40
    subject[:timeout] = "40"
    subject[:timeout].should == 40
  end

end