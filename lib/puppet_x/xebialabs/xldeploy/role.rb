require 'pathname'
require 'rexml/document'


require File.join(File.dirname(__FILE__), 'xldeploy')

class User < Xldeploy

  attr_accessor :id, :granted_permissions, :users

  def initialize(rest_url, id, granted_permissions, users, ssl=false, verify_ssl=true)
    @id       = id
    @users    = users
    super(rest_url, ssl, verify_ssl)
  end

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