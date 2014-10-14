require 'puppet'
require 'open-uri'
require 'rexml/document'

require File.join(File.dirname(__FILE__), 'task_info')
require File.join(File.dirname(__FILE__), 'deployment')
require File.join(File.dirname(__FILE__), 'security')
require File.join(File.dirname(__FILE__), 'repository')
require File.join(File.dirname(__FILE__), 'tasks')
require File.join(File.dirname(__FILE__), 'configuration_item')
require File.join(File.dirname(__FILE__), 'application')
require File.join(File.dirname(__FILE__), 'multipart')

class XLDeployCommunicator
  def initialize(endpoint, username, password, context)
    raise 'XL Deploy communicator endpoint is nil or empty' if endpoint.nil?
    raise 'XL Deploy communicator username is nil or empty' if username.nil?
    raise 'XL Deploy communicator password is nil or empty' if password.nil?

    url = URI.parse(endpoint)
    @connection = Net::HTTP.new(url.host, url.port)
    @connection.use_ssl = false
    @username=username
    @password=password
    @context=context
    @types={}
    @str = "XL Deploy Communicator #{endpoint}#{@context}";
  end

  def contexted(path)
    if @context == '/'
      path
    else
      @context + path
    end
  end

  def do_get(path)
    execute(Net::HTTP::Get.new(URI::encode contexted(path)))
  end

  def do_delete(path)
    execute(Net::HTTP::Delete.new(URI::encode contexted(path)))
  end

  def do_put(path)
    execute(Net::HTTP::Put.new(URI::encode contexted(path)))
  end

  def do_put(path, xml)
    request = Net::HTTP::Put.new(URI::encode contexted(path))
    request.body = xml
    request.add_field 'Content-Type', 'application/xml'
    execute(request)
  end


  def do_post(path, xml)
    request = Net::HTTP::Post.new(URI::encode contexted(path))
    request.body = xml
    request.add_field 'Content-Type', 'application/xml'
    execute(request)
  end

  def do_post_multipart(path, input_parts)
    #based on http://stanislavvitvitskiy.blogspot.fr/2008/12/multipart-post-in-ruby.html
    boundary = '----RubyMultipartClient' + rand(1000000).to_s + 'ZZZZZ'

    #build the parts
    parts = []
    streams = []
    input_parts.each do |param_name, filepath|
      pos = filepath.rindex('/')
      filename = filepath[pos + 1, filepath.length - pos]
      parts << StringPart.new('--' + boundary + "\r\n" +
                                  "Content-Disposition: form-data; name=\"" + param_name.to_s + "\"; filename=\"" + filename + "\"\r\n" +
                                  "Content-Type: application/octet-stream\r\n\r\n")
      stream = File.open(filepath, 'rb')
      streams << stream
      parts << StreamPart.new(stream, File.size(filepath))
    end
    parts << StringPart.new("\r\n--" + boundary + "--\r\n")
    post_stream = MultipartStream.new(parts)
    request = Net::HTTP::Post.new(URI::encode contexted(path))
    request.basic_auth @username, @password
    request.content_length = post_stream.size
    request.content_type = 'multipart/form-data; boundary=' + boundary
    request.body_stream = post_stream
    execute(request)

    streams.each do |stream|
      stream.close();
    end


  end

  def to_s
    @str
  end

  private

  def type(name)
    doc = do_get "/deployit/metadata/type/#{name}"
    @types[name]=Hash[doc.elements.to_a('/descriptor/property-descriptors/property-descriptor').map { |x| [x.attributes['name'], x] }]
  end

  def execute(request)
    #TODO: manage errors when the remote server is not available (eg not started)
    request.basic_auth @username, @password
    res = @connection.request(request)

    raise Puppet::Error, "cannot send request to XL Deploy server #{res.code}/#{res.message}:#{res.body}" unless res.is_a?(Net::HTTPSuccess)
    REXML::Document.new res.body
  end

  public
  def to_xml(ci)
    pd=type(ci.type)
    doc = REXML::Document.new
    root = doc.add_element ci.type, {'id' => ci.id}
    ci.properties.each do |key, value|
      property = root.add_element(key)
      #Puppet.debug(" to_xml::processing #{key}:#{value}")
      case pd[key].attributes['kind']
        when 'SET_OF_STRING', 'LIST_OF_STRING'
          value.each do |v|
            property.add_element('value').text = v
          end
        when 'SET_OF_CI', 'LIST_OF_CI'
          value.each do |v|
            property.add_element('ci', {'ref' => v})
          end
        when 'MAP_STRING_STRING'
          value.each do |k, v|
            property.add_element('entry', {'key' => k}).text = v
          end
        when 'CI'
          property.add_attribute('ref', value)
        else
          property.text = value
      end

    end
    Puppet.debug " to_xml::#{doc.to_s}"
    doc.to_s()
  end


  def from_xml(doc)
    ci = ConfigurationItem.new(doc.root.name, doc.root.attributes["id"])
    pd=type(ci.type)
    doc.elements.each("/*/*") do |prop|
      case pd[prop.name].attributes["kind"]
        when 'SET_OF_STRING', 'LIST_OF_STRING'
          values = []
          prop.elements.each("//#{prop.name}/value") { |v|
            values << v.text
          }
          ci.properties[prop.name]=values
        when 'SET_OF_CI', 'LIST_OF_CI'
          values = []
          prop.elements.each("//#{prop.name}/ci") { |v|
            values << v.attributes['ref']
          }
          ci.properties[prop.name]=values
        when 'MAP_STRING_STRING'
          values = {}
          prop.elements.each("//#{prop.name}/entry") { |v|
            values[v.attributes['key']]=v.text
          }
          ci.properties[prop.name]=values
        when 'CI'
          ci.properties[prop.name]=prop.attributes['ref']
        else
          ci.properties[prop.name]=prop.text

      end
    end
    ci
  end

end


#end



