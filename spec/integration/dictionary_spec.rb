require 'spec_helper'

describe PuppetXLDeployModule do

  it 'manages dictionary ' do

    communicator = XLDeployCommunicator.new('http://localhost:4516', 'admin', 'admin', '/')
    repository = Repository.new(communicator)

    run_puppet_command_with_file 'dictionary_c.pp'
    repository.exists?('Environments/dict1').should == true
    d=repository.read('Environments/dict1')
    d['entries']['A'].should == "1"
    d['entries']['B'].should == "2"
    d['restrictToContainers'].should include 'Infrastructure/host.dict'


    run_puppet_command_with_file 'dictionary_u.pp'
    repository.exists?('Environments/dict1').should == true
    d=repository.read('Environments/dict1')
    d['entries']['A'].should == "1"
    d['entries']['B'].should == "3"
    d['restrictToContainers'].should include 'Infrastructure/host_next.dict'

    run_puppet_command_with_file 'dictionary_d.pp'
    repository.exists?('Environments/dict1').should == false

    run_puppet_command_with_file 'dictionary_clean.pp'

  end

end