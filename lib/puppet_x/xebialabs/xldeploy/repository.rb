require 'digest/sha1'

class Repository

  def initialize(communicator)
    @communicator=communicator
  end

  def exists?(id)
    doc = @communicator.do_get "/deployit/repository/exists/#{id}"
    '<boolean>true</boolean>' == doc.elements['//boolean'].to_s
  end

  def read(id)
    doc = @communicator.do_get "/deployit/repository/ci/#{id}"
    @communicator.from_xml(doc)
  end

  def create(ci)
    doc = @communicator.to_xml(ci)
    newdoc = @communicator.do_post "/deployit/repository/ci/#{ci.id}", doc
    @communicator.from_xml(newdoc)
  end

  def readOrCreate(id, type)
    if not exists?(id)
      create(ConfigurationItem.new(type, id))
    end
    read(id)
  end

  def update(ci)
    doc = @communicator.to_xml(ci)
    newdoc = @communicator.do_put "/deployit/repository/ci/#{ci.id}", doc
    @communicator.from_xml(newdoc)
  end

  def delete(id)
    @communicator.do_delete "/deployit/repository/ci/#{id}"
  end

  def search_by_type(type)
    ids =[]
    doc = @communicator.do_get "/deployit/repository/query?type=#{type}"
    doc.root.each_element_with_attribute('ref') { |e| ids << e.attributes['ref'] }
    ids
  end

  def encrypt(message, dictionary_id)
    ci = ConfigurationItem.new('udm.EncryptedDictionary', dictionary_id)
    create(ci) unless exists?(dictionary_id)
    message_key = Digest::SHA1.hexdigest(message)
    ci['entries']={message_key => message}
    ci = update(ci)
    #remove e{...}
    #the encrypted entry is like this: <entry key="scott">e{{b64}Xq9v4lVQl77Vcuehs/DwPA==}</entry>
    encrypted_password = ci['entries'][message_key].gsub(/e\{/, '').gsub(/\}$/, '')
    ci['entries'].delete(message_key)
    update(ci)
    encrypted_password
  end
end
