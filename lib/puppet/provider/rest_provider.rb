require 'puppet'
require 'open-uri'
require 'net/http'
#require 'xmlsimple'
require 'rexml/document'
require 'puppet_x/xebialabs/xldeploy/configuration_item.rb'


#require 'puppet_x/xebialabs/xldeploy/communicator.rb'

class Puppet::Provider::XLDeployRestProvider < Puppet::Provider

  # def rest_get(service)
  #   begin
  #     response = RestClient.get "#{resource[:rest_url]}/#{service}", {:accept => :xml, :content_type => :xml }
  #   rescue Exception => e
  #     return e.message
  #   end
  # end
  #
  # def rest_post(service, body='')
  #   RestClient.post "#{resource[:rest_url]}/#{service}", body, {:content_type => :xml }
  # end
  #
  # def rest_put(service, body='')
  #   RestClient.put "#{resource[:rest_url]}/#{service}", body, {:content_type => :xml }
  # end
  #
  # def rest_delete(service)
  #   RestClient.delete "#{resource[:rest_url]}/#{service}", {:accept => :xml, :content_type => :xml }
  # end

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

    uri = URI.parse("#{resource[:rest_url]}/#{service}")

    http = Net::HTTP.new(uri.host, uri.port)
    request = case method
                when 'get'    then Net::HTTP::Get.new(uri.request_uri)
                when 'post'   then Net::HTTP::Post.new(uri.request_uri)
                when 'put'    then Net::HTTP::Put.new(uri.request_uri)
                when 'delete' then Net::HTTP::Delete.new(uri.request_uri)
              end
    #p request.pretty_print_inspect

    request.basic_auth(uri.user, uri.password) if uri.user and uri.password
    request.body = body unless body == ''
    request.content_type = 'application/xml'

    begin
      res = http.request(request)
      raise Puppet::Error, "cannot send request to deployit server #{res.code}/#{res.message}:#{res.body}" unless res.is_a?(Net::HTTPSuccess)
      return res.body
    rescue Exception => e
      return e.message
    end

  end

  # def to_xml(id, type, properties)
  #   props = {'@id' => id}.merge(properties)
  #   XmlSimple.xml_out(
  #     props,
  #     {
  #       'RootName'   => type,
  #       'AttrPrefix' => true,
  #       'GroupTags'  => {
  #         'tags'         => 'value',
  #         'servers'      => 'ci',
  #         'members'      => 'ci',
  #         'dictionaries' => 'ci',
  #         'entries'      => 'entry'
  #       },
  #     }
  #   )
  # end
  #
  #
  #
  # def to_hash(xml)
  #   XmlSimple.xml_in(
  #     xml,
  #     {
  #       'ForceArray' => false,
  #       'AttrPrefix' => true,
  #       'GroupTags'  => {
  #         'tags'         => 'value',
  #         'servers'      => 'ci',
  #         'members'      => 'ci',
  #         'dictionaries' => 'ci',
  #         'entries'      => 'entry'
  #       },
  #     }
  #   )
  # end
  #

  def type(name)
    @types={}
    doc = REXML::Document.new(rest_get "/deployit/metadata/type/#{name}")
    @types[name]=Hash[doc.elements.to_a('/descriptor/property-descriptors/property-descriptor').map { |x| [x.attributes['name'], x] }]
  end

  def to_xml(id, type, properties)
    pd=type(type)
    Puppet.debug "Property definition #{pd}"
    Puppet.debug "Proposed properties #{properties}"
    doc = REXML::Document.new
    root = doc.add_element type, {'id' => id}
    properties.each do |key, value|
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

    end unless properties.nil?
    Puppet.debug " to_xml::#{doc.to_s}"
    doc.to_s()
  end


  def to_hash(input)
    p input
    doc = REXML::Document.new input
    ci = ConfigurationItem.new(doc.root.name, doc.root.attributes["id"])
    pd=type(ci.type)
    p pd
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
    ci.to_h
  end


end


