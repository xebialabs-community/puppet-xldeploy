require File.join(File.dirname(__FILE__), 'xldeploy')

class Dictionary_entry < Xldeploy

  attr_accessor :key, :value, :encrypted, :dictionary_content

  def initialize(rest_url,dict_key,value, ssl=false, verify_ssl=true, encrypted = false)

    @key   = dict_key
    @value = value
    @encrypted = encrypted

    # super(rest_url, ssl, verify_ssl)
    super(rest_url)

    @dictionary_content = get_dictionary_entries
  end

  def get_dictionary_entries
    if dictionary_exists?
      dict_xml = rest_get "repository/ci/#{dictionary}"
      dict_hash = to_hash(dict_xml)

      return dict_hash['entries']
    else
      return {}
    end

  end

  def persist

    @dictionary_content = get_dictionary_entries

    unless value_correct?
      @dictionary_content[key_name] = value
    end

    dict_xml = to_xml(dictionary, dictionary_type, {'entries' => @dictionary_content})

    if dictionary_exists?
      rest_put "repository/ci/#{dictionary}", dict_xml
    else
      rest_post "repository/ci/#{dictionary}", dict_xml
    end
  end

  def destroy
    @dictionary_content = get_dictionary_entries

    if key_exists?
      @dictionary_content.delete(key_name)
    end

    dict_xml = to_xml(dictionary, dictionary_type, {'entries' => @dictionary_content})


    rest_put "repository/ci/#{dictionary}", dict_xml

  end

  def dictionary
    Pathname.new(@key).dirname.to_s
  end

  def key_name
    Pathname.new(@key).basename.to_s
  end


  def dictionary_type
    if dictionary_exists?
      return get_ci_type(dictionary)
    else
      if encrypted
        return 'udm.EncrypedDictionary'
      else
        return 'udm.Dictionary'
      end
    end
  end

  def dictionary_exists?
    ci_exists?(dictionary)
  end

  def key_exists?
    if dictionary_exists?
     dictionary_content.each {|k,v| return true if k == key_name } unless dictionary_content.empty?
    end
    return false
  end

  def value_correct?
    if dictionary_exists?
      if key_exists?
         dictionary_content.each {|k,v| return true if k == key_name and v == value } unless dictionary_content.empty?
      end
    end
    return false
  end

  def current_value
    if dictionary_exists?
      if key_exists?
        return dictionary_content[key_name]
      end
    end
    return false
  end

end