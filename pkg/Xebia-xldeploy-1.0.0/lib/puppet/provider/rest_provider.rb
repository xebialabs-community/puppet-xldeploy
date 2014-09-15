require 'puppet'
#require 'puppet_x/xebialabs/xldeploy/communicator.rb'

class Puppet::Provider::XLDeployRestProvider < Puppet::Provider

  def rest_get(service)
    begin
      response = RestClient.get "#{resource[:rest_url]}/#{service}", {:accept => :xml, :content_type => :xml }
    rescue Exception => e
      return e.message
    end
  end

  def rest_post(service, body='')
    RestClient.post "#{resource[:rest_url]}/#{service}", body, {:content_type => :xml }
  end

  def rest_put(service, body='')
    RestClient.put "#{resource[:rest_url]}/#{service}", body, {:content_type => :xml }
  end

  def rest_delete(service)
    RestClient.delete "#{resource[:rest_url]}/#{service}", {:accept => :xml, :content_type => :xml }
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


