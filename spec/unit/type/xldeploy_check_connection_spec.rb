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

  it 'should accept a hostname' do
    subject[:host] = "testhost"
    subject[:host].should == "testhost"
  end

  it 'should fail when port gets passed a string' do
    expect  { subject[:port] = 'crap_in_a_box' }.to raise_error(Puppet::ResourceError)
  end

  it 'should run when port gets passed an integer or a integer masked as a string' do
    subject[:port] = 4516
    subject[:port].should == 4516
    subject[:port] = "4516"
    subject[:port].should == 4516
  end
  it 'should run when timeout gets passed an integer or a integer masked as a string' do
    subject[:timeout] = 40
    subject[:timeout].should == 40
    subject[:timeout] = "40"
    subject[:timeout].should == 40
  end

end