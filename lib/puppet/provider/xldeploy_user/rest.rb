Puppet::Type.type(:xldeploy_user).provide :rest, :parent => Puppet::Provider::XLDeployRestProvider do

  confine :feature => :restclient

  has_feature :restclient

  def create
    props = {'@admin' => false, 'username' => resource[:id], 'password' => resource[:password] }
    xml = XmlSimple.xml_out(
      props,
      {
        'RootName'   => 'user',
        'AttrPrefix' => true,
      }
    )
    rest_post "security/user/#{resource[:id]}", xml
  end

  def destroy
    rest_delete "security/user/#{resource[:id]}"
  end

  def exists?
    response = rest_get "security/user/#{resource[:id]}"
    if response =~ /No such user/
      return false
    else
      return true
    end
  end
end
