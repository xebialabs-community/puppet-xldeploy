require 'spec_helper_acceptance'

describe 'xldeploy class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'xldeploy::server':
        download_user => 'download',
        download_password => '<change me>',
        install_java          =>  true,
        install_license       =>  true,
        version               => '4.5.2',
        ssl                   => false,
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end


    describe port(4516) do
      it { should be_listening }
    end

    describe user('xldeploy') do
      it {should exist}
    end

    describe file('/opt/xl-deploy/xl-deploy-4.5.2-server') do
      it {should be_directory}
    end

  end
end