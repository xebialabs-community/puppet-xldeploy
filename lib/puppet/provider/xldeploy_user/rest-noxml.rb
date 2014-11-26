require 'puppet_x/xebialabs/xldeploy/user.rb'

Puppet::Type.type(:xldeploy_user).provide :rest  do



  def create
   user.create
  end

  def destroy
    user.destroy
  end

  def exists?
    user.exists?
  end

  private

  def user

    User.new(resource[:rest_url], resource[:id], resource[:password], resource[:ssl], resource[:verify_ssl])

  end
end
