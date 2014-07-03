require 'uri'

Puppet::Type.type(:xldeploy_role).provide :rest, :parent => Puppet::Provider::XLDeployRestProvider do

  confine :feature => :restclient

  has_feature :restclient

  def create
    rest_put("security/role/#{resource[:id]}")
  end

  def destroy
    rest_delete "security/role/#{resource[:id]}"
  end

  def exists?
    response = rest_get "security/role"
    if to_hash(response).has_key?('string')
      return true if to_hash(response)['string'].include? resource[:id]
    end
    return false
  end

  def granted_permissions
    output = {}

    resource[:granted_permissions].each do | ci, perm |
      if perm.is_a? Array
        output[ci] = []
        perm.each {| pe |  output[ci] << pe if has_permission(ci, resource[:id], pe) == true }
      else
        output[ci] = perm if has_permission(ci, resource[:id], perm) == true
      end
   end
    return output
  end

  def granted_permissions=(value)
    value.each do |ci, perm|
      if perm.is_a? Array
        perm.each {|pe| set_permission(ci,resource[:id], pe) }
      else
         set_permission(ci,resource[:id], perm)
      end
    end
  end

  def users
    output = []
    resource[:users].each do | user |
     output << user if has_role(user, resource[:id])
    end
  end

  def users=(value)
    assign_role(value, resource[:id])
  end

  #private
 def has_role(user,role)
    response = rest_get("security/role/roles/#{user}")
    return true if response =~ /#{role}/
    return false
  end

 def assign_role(user,role)
    rest_put("security/role/#{role}/#{user}")
 end

  def has_permission(ci,role,permission)
    response = rest_get("security/permission/#{URI.escape(permission)}/#{role}/#{ci}")
    return true if response =~ /true/
    return false
  end

  def set_permission(ci,role,permission)
    rest_put("security/permission/#{URI.escape(permission)}/#{role}/#{ci}")
  end

end
