require 'pathname'

Puppet::Type.type(:xldeploy_environment_member).provide :rest, :parent => Puppet::Provider::XLDeployRestProvider do

  confine :feature => :restclient

  has_feature :restclient

  def create
    new_members = (resource[:members] + members).uniq.map{ |item| {'@ref' => item} }
    new_dictionaries = (resource[:dictionaries] + dictionaries).uniq.map{ |item| {'@ref' => item} }

    @property_hash['env'].values[0]['members'] = new_members
    @property_hash['env'].values[0]['dictionaries'] = new_dictionaries
  end

  def destroy
    new_members = (members - resource[:members]).map{ |item| {'@ref' => item} }
    new_dictionaries = (dictionaries - resource[:dictionaries]).map{ |item| {'@ref' => item} }
    @property_hash['env'].values[0]['members'] = new_members
    @property_hash['env'].values[0]['dictionaries'] = new_dictionaries
  end

  def exists?
    get_environment

    (resource[:members] - members).length == 0 and (resource[:dictionaries] - dictionaries).length == 0
  end

  def members
    @property_hash['env'].values[0]['members'].map{ |item| item['@ref'] }
  end

  def members=(value)
    new_members = (resource[:members] + members).uniq.map{ |item| {'@ref' => item} }
    @property_hash['env'].values[0]['members'] = new_members
  end

  def dictionaries
    @property_hash['env'].values[0]['dictionaries'].map{ |item| item['@ref'] }
  end

  def dictionaries=(value)
    new_dictionaries = (resource[:dictionaries] + dictionaries).uniq.map{ |item| {'@ref' => item} }
    @property_hash['env'].values[0]['dictionaries'] = new_dictionaries
  end

  def flush
    update_environment
  end

  private

  def get_environment
    env_xml = rest_get "repository/ci/#{resource[:env]}"
    env_hash = to_hash(env_xml)

    # Check if members is already an Array
    # if not we have to initialize it to a new array if empty
    # or wrap the existing value otherwise
    mem = env_hash.values[0]['members']
    unless mem.is_a? Array then
      if mem.empty? then
        env_hash.values[0]['members'] = Array[]
      else
        env_hash.values[0]['members'] = Array[mem]
      end
    end

    # Check if dictionaries is already an Array
    # if not we have to initialize it to a new array if empty
    # or wrap the existing value otherwise
    dict = env_hash.values[0]['dictionaries']
    unless dict.is_a? Array then
      if dict.empty? then
        env_hash.values[0]['dictionaries'] = Array[]
      else
        env_hash.values[0]['dictionaries'] = Array[dict]
      end
    end

    @property_hash['env'] = env_hash
  end

  def update_environment
    env_xml = to_xml(@property_hash['env'])
    rest_put "repository/ci/#{resource[:env]}", env_xml
  end
end
