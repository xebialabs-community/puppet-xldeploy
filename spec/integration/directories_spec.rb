require 'spec_helper'

describe PuppetXLDeployModule do

  it 'manages directories' do

    communicator = XLDeployCommunicator.new('http://localhost:4516', 'admin', 'admin', '/')
    repository = Repository.new(communicator)

    run_puppet_command_with_file 'directory_c.pp'
    repository.exists?('Infrastructure/dir1').should == true
    repository.exists?('Infrastructure/dir1/dir2').should == true

    run_puppet_command_with_file 'directory_d.pp'
    repository.exists?('Infrastructure/dir1').should == false

  end


end