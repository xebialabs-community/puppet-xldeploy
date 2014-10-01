class Security
  def initialize(communicator)
    @communicator=communicator
  end

  def granted?(permission, role, id)
    doc = @communicator.do_get "/deployit/security/permission/#{permission}/#{role}/#{id}"
    '<boolean>true</boolean>' == doc.elements['//boolean'].to_s
  end

  def grant(permission, role, id)
    @communicator.do_put "/deployit/security/permission/#{permission}/#{role}/#{id}", ''
  end

  def revoke(permission, role, id)
    @communicator.do_delete "/deployit/security/permission/#{permission}/#{role}/#{id}"
  end

  def create_role(role)
    @communicator.do_put "/deployit/security/role/#{role}", ''
  end

  def delete_role(role)
    @communicator.do_delete "/deployit/security/role/#{role}"
  end

  def role_exist?(role)
    doc = @communicator.do_get  "/deployit/security/role/"
    REXML::XPath.first(doc, "/list/string[text()='#{role }']") != nil
  end


end
