
require 'puppet'
require 'pathname'
require 'puppet/type/xldeploy_ci'

describe Puppet::Type.type(:xldeploy_ci) do
  subject { Puppet::Type.type(:xldeploy_ci).new(:title => 'Environments/tester')}

  # ensure
  it 'should accept ensure' do
    subject[:ensure] = :present
    subject[:ensure].should == :present
    subject[:ensure] = :absent
    subject[:ensure].should == :absent
  end

  # id

  it 'should accept a valid id' do
    subject[:id] = 'Environments/test'
    subject[:id].should == 'Environments/test'
    subject[:id] = 'Infrastructure/test'
    subject[:id].should == 'Infrastructure/test'
    subject[:id] = 'Applications/test'
    subject[:id].should == 'Applications/test'
    subject[:id] = 'Configuration/test'
    subject[:id].should == 'Configuration/test'
  end

  it 'should raise an error whe a invalid id is given' do
    expect  { subject[:id] = 'crap_in_a_box' }.to raise_error(Puppet::ResourceError)
  end

  # properties
  it 'should accept a hash as input to properties' do
    subject[:properties] = {'test' => ' test', 'test1' => 'test1' }
    subject[:properties].should == {'test' => ' test', 'test1' => 'test1' }
  end

  it 'should substitute a empty hash when no properties specified' do
    subject[:properties].should == {}
  end

  it 'should raise an error when properties gets passed a String' do
    expect  { subject[:properties] = 'crap_in_a_box' }.to raise_error(Puppet::ResourceError)
  end

  # discovery
  it 'should accept a hash as input to discovery' do
    subject[:discovery] = true
    subject[:discovery].should == true
    subject[:discovery] = false
    subject[:discovery].should == false
  end

  it 'should raise an error when discovery gets passed a String' do
    expect  { subject[:discovery] = 'crap_in_a_box' }.to raise_error(Puppet::ResourceError)
  end

# discovery_max_wait
  it 'should accept a integer as input to discovery_max_wait' do
    subject[:discovery_max_wait] = 110
    subject[:discovery_max_wait].should == 110
  end

  it 'should raise an error when properties gets passed a String' do
    expect  { subject[:discovery_max_wait] = 'crap_in_a_box' }.to raise_error(Puppet::ResourceError)
  end

  # rest_url
  it 'should accept a url as input to rest_url' do
    subject[:rest_url] = 'http://localhost:4516/xldeploy'
    subject[:rest_url].should == 'http://localhost:4516/xldeploy'
  end


end