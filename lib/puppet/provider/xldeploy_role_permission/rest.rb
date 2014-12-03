require 'uri'
require 'puppet_x/xebialabs/xldeploy/xldeploy.rb'


Puppet::Type.type(:xldeploy_role_permission).provide :rest  do

  def initialize
    xldeploy = Xldeploy.new(resource[:rest_url], resource[:ssl], resource[:verify_ssl])
  end


  def granted_permissions
    output = []

    resource[:cis].each do |ci|
      resource[:granted_permissions].each do | perm |
        output << perm if has_permission(ci, resource[:role], perm)
      end
    end

    return output
  end

  def granted_permissions=(value)
    resource[:cis].each do |ci|
      value.each do |perm|
        if perm.is_a? Array
          perm.each {|pe| set_permission(ci,resource[:role], pe) }
        else
          set_permission(ci,resource[:role], perm)
        end
      end
    end
  end

  def has_role(user,role)
    response = xldeploy.rest_get("security/role/roles/#{user}")
    return true if response =~ /#{role}/
    return false
  end

  def assign_role(user,role)
    xldeploy.rest_put("security/role/#{role}/#{user}")
  end

  def has_permission(ci,role,permission)
    response = xldeploy.rest_get("security/permission/#{URI.escape(permission)}/#{role}/#{ci}")
    return true if response =~ /true/
    return false
  end

  def set_permission(ci,role,permission)
    xldeploy.rest_put("security/permission/#{URI.escape(permission)}/#{role}/#{ci}")
  end
  private
  def xldeploy
    Xldeploy.new(resource[:rest_url], resource[:ssl], resource[:verify_ssl])
  end
end
