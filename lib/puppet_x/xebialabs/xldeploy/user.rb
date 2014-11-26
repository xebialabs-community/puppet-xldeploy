require 'pathname'
require 'rexml/document'


require File.join(File.dirname(__FILE__), 'xldeploy')

class User < Xldeploy

  attr_accessor :id, :password, :admin

  def initialize(rest_url, id, password, ssl=false, verify_ssl=true)
    @id       = id
    @password = password
    @admin    = false
    super(rest_url, ssl, verify_ssl)
  end

  def create
    rest_post "security/user/#{id}", to_xml
  end

  def destroy
    rest_delete "security/user/#{id}"
  end

  def exists?
    response = rest_get "security/user/#{id}"
    unless response =~ /<username>#{id}<\/username>/
      return false
    else
      return true
    end
  end

  def to_xml
    doc = REXML::Document.new
    root = doc.add_element "user", {'admin' => admin }
    property = root.add_element('username')
    property.text = @id
    property2 = root.add_element('password')
    property2.text = @password
    doc.to_s()
  end
end

