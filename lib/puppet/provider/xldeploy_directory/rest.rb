require 'puppet/provider/xldeploy_cli_provider'

Puppet::Type.type(:xldeploy_directory).provide :rest, :parent => Puppet::Provider::XlDeployCliProvider do

  @doc = 'Manage a Xldeploy core.Directory CI using http protocol'

  def exists?
    repository.exists? @resource[:id]
  end

  def create
    repository.create to_ci
  end

  def destroy
    repository.delete @resource[:id]
  end

  def to_ci
    ConfigurationItem.new(@resource[:type], @resource[:id])
  end

end

