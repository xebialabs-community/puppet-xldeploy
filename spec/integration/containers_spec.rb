require 'spec_helper'

describe PuppetXLDeployModule do

  it 'manages containers' do

    communicator = XLDeployCommunicator.new('http://localhost:4516', 'admin', 'admin', '/')
    repository = Repository.new(communicator)

    run_puppet_command_with_file 'hosts_c.pp'
    repository.exists?('Infrastructure/simple.host').should == true
    repository.exists?('Infrastructure/simple.host.with.tags').should == true
    repository.read('Infrastructure/simple.host.with.tags')['tags'].should include 'front'
    repository.read('Infrastructure/simple.host.with.tags')['tags'].should include 'back'
    repository.read('Infrastructure/simple.host.with.tags')['tags'].should include 'admin'


    run_puppet_command_with_file 'hosts_u.pp'
    repository.read('Infrastructure/simple.host')['username'].should == 'lion'
    repository.read('Infrastructure/simple.host')['address'].should == '192.168.0.10'
    repository.read('Infrastructure/simple.host')['os'].should == 'UNIX'
    repository.read('Infrastructure/simple.host.with.tags')['tags'].should include 'front'
    repository.read('Infrastructure/simple.host.with.tags')['tags'].should include 'back'

    run_puppet_command_with_file 'hosts_d.pp'
    repository.exists?('Infrastructure/simple.host').should == false
    repository.exists?('Infrastructure/simple.host.with.tags').should == false

  end

end