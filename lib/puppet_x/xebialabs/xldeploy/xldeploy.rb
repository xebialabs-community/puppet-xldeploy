require 'open-uri'
require 'net/http'
require 'rexml/document'

class Xldeploy

  attr_accessor :rest_url, :ssl , :verify_ssl

  def initialize(rest_url, ssl = false, verify_ssl = true)
    @rest_url   = rest_url
    @verify_ssl = verify_ssl
    @ssl        = ssl
  end

  def rest_get(service)
    execute_rest(service, 'get')
  end

  def rest_post(service, body='')
    execute_rest(service, 'post', body)
  end

  def rest_put(service, body='')
    execute_rest(service, 'put', body)
  end

  def rest_delete(service)
    execute_rest(service, 'delete')
  end

  def execute_rest(service, method, body='')
    uri = URI.parse("#{rest_url}/#{service}")
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = ssl
    unless verify_ssl
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end


    request = case method

                when 'get'    then Net::HTTP::Get.new(uri.request_uri)
                when 'post'   then Net::HTTP::Post.new(uri.request_uri)
                when 'put'    then Net::HTTP::Put.new(uri.request_uri)
                when 'delete' then Net::HTTP::Delete.new(uri.request_uri)
              end

    request.basic_auth(uri.user, uri.password) if uri.user and uri.password
    request.body = body unless body == ''
    request.content_type = 'application/xml'

    begin
      res = http.request(request)
      #raise Puppet::Error, "cannot send request to deployit server #{res.code}/#{res.message}:#{res.body}" unless res.is_a?(Net::HTTPSuccess)
      return res.body
    rescue Exception => e
      return e.message
    end

  end

  def type_description(type=@type)
    output = rest_get("metadata/type/#{type}")
    p output
    doc = REXML::Document.new output
    p doc
    Hash[doc.elements.to_a('/descriptor/property-descriptors/property-descriptor').map { |x| [x.attributes['name'], x] }]
  end

  def get_task_state(task)
    get_task(task)['state']
  end

  def get_task(task)
    output = rest_get "task/#{task}"
    doc = REXML::Document.new output
    doc.root.attributes
  end



  def to_xml(id, type, properties)
    doc = REXML::Document.new
    root = doc.add_element type, {'id' => id}
    properties.each do |key, value|
      property = root.add_element(key)

      #Puppet.debug(" to_xml::processing #{key}:#{value}")
      case type_description(type)[key].attributes['kind']
        when 'SET_OF_STRING', 'LIST_OF_STRING'
          value = [value] if value.is_a?(String)
          value.each do |v|
            property.add_element('value').text = v
          end
        when 'SET_OF_CI', 'LIST_OF_CI'
          value.each do |v|
            v = v.values[0] if v.is_a?(Hash)
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

    end unless properties.nil?
    doc.to_s()
  end


  def to_hash(input, output='properties')
    doc = REXML::Document.new input
    data_hash = { 'name' => doc.root.name , 'id' => doc.root.attributes["id"], 'properties' => {}}
    pd=type_description(doc.root.name)
    unless pd.empty?
      doc.elements.each("/*/*") do |prop|
        case pd[prop.name].attributes["kind"]
          when 'SET_OF_STRING', 'LIST_OF_STRING'
            values = []
            prop.elements.each("//#{prop.name}/value") { |v|
              values << v.text
            }
            if values.is_a?(String)
              data_hash['properties'][prop.name]="#{values}"
            else
              values = "" if values.empty?
              values = values[0] if values.length == 1
              data_hash['properties'][prop.name]=values
            end
          when 'SET_OF_CI', 'LIST_OF_CI'
            values = []
            prop.elements.each("//#{prop.name}/ci") { |v|
              values << v.attributes['ref']
            }
            data_hash['properties'][prop.name]=values
          when 'MAP_STRING_STRING'
            values = {}
            prop.elements.each("//#{prop.name}/entry") { |v|
              values[v.attributes['key']]=v.text
            }
            data_hash['properties'][prop.name]=values
          when 'CI'
            data_hash['properties'][prop.name]=prop.attributes['ref']
          else
            data_hash['properties'][prop.name]=prop.text

        end
      end
    end
    data_hash["#{output}"]
  end

  def reachable?
    uri = URI(rest_url)

    begin
      Timeout::timeout(1) do
        begin
          s = TCPSocket.new(uri.host, uri.port)
          s.close
          return true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          return false
        end
      end
    rescue Timeout::Error
    end

    return false
  end

  def ci_exists?(ci)
    xml = rest_get "repository/exists/#{ci}"
    doc = REXML::Document.new xml
    return doc.elements[1].text == 'true'
  end

  def get_ci_type(id)
    output = rest_get("repository/ci/#{id}")
    doc = REXML::Document.new output
    doc.root.name
  end

end


