require 'pathname'

Puppet::Type.type(:xldeploy_dictionary_entry).provide :rest, :parent => Puppet::Provider::XLDeployRestProvider do

  confine :feature => :restclient

  has_feature :restclient

  def create
    entries = @property_hash['dictionary'].values[0]['entries']
    entries << { '@key' => key, 'content' => resource[:value] }
  end

  def destroy
    entries = @property_hash['dictionary'].values[0]['entries']
    entries.delete_if { |a| a['@key'] == key }
  end

  def exists?

    get_dictionary

    entries = @property_hash['dictionary'].values[0]['entries']
    entries.each do |a|
      return true if a['@key'] == key
    end
    false
  end

  def value
    entries = @property_hash['dictionary'].values[0]['entries']
    entries.each do |a|
      return a['content'] if a['@key'] == key
    end
  end

  def value=(value)
    entries = @property_hash['dictionary'].values[0]['entries']
    entries.each do |a|
      a['content'] = resource[:value] if a['@key'] == key
    end
  end

  def flush
    update_dictionary
  end

  private

  def get_dictionary
    dict_xml = rest_get "repository/ci/#{dictionary}"
    dict_hash = to_hash(dict_xml)

    # Check if entries is already an Array
    # if not we have to initialize it to a new array if empty
    # or wrap the existing value otherwise
    entries = dict_hash.values[0]['entries']
    unless entries.is_a? Array then
      if entries.empty? then
        dict_hash.values[0]['entries'] = Array[]
      else
        dict_hash.values[0]['entries'] = Array[entries]
      end
    end
    @property_hash['dictionary'] = dict_hash
  end

  def update_dictionary
    dict_xml = to_xml(@property_hash['dictionary'])
    rest_put "repository/ci/#{dictionary}", dict_xml
  end

  def dictionary
    Pathname.new(resource[:key]).dirname.to_s
  end

  def key
    Pathname.new(resource[:key]).basename.to_s
  end
end
