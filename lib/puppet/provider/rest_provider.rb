require 'puppet'
require 'open-uri'
require 'net/http'

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
  
  def to_xml(id, type, properties)
    props = {'@id' => id}.merge(properties)
    XmlSimple.xml_out(
      props,
      {
        'RootName'   => type,
        'AttrPrefix' => true,
        'GroupTags'  => {
          'tags'         => 'value',
          'servers'      => 'ci',
          'members'      => 'ci',
          'dictionaries' => 'ci',
          'entries'      => 'entry'
        },
      }
    )
  end

  def to_hash(xml)
    XmlSimple.xml_in(
      xml,
      {
        'ForceArray' => false,
        'AttrPrefix' => true,
        'GroupTags'  => {
          'tags'         => 'value',
          'servers'      => 'ci',
          'members'      => 'ci',
          'dictionaries' => 'ci',
          'entries'      => 'entry'
        },
      }
    )
  end
end


