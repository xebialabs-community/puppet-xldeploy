require File.join(File.dirname(__FILE__), 'xldeploy')

class Password < Xldeploy

  attr_accessor :translated, :plain_text

  def initialize(rest_url, plain_text, ssl, verify_ssl)
    super(rest_url, ssl, verify_ssl)
    @plain_text = plain_text
    @translated = translate
  end

  def translate

      tmpDict         = 'Environments/puppet_tmp_dict'
      deployitType    = 'udm.EncryptedDictionary'

      #compose the xml
      xml = to_xml(tmpDict, deployitType, {'entries' => { plain_text => plain_text} })

      # create the dictionary in deployit
      rest_post("repository/ci/#{tmpDict}", xml)

      # get the dictionary from deployit
      xml = rest_get("repository/ci/#{tmpDict}")
      # extract the passwordhash from te dictionary
      passwordHash = to_hash(xml)['entries'][plain_text]

      # remove the dictionary
      rest_delete("repository/ci/#{tmpDict}" )

      # return the hash
      # we have to cut the first two and de last char of the bloody thing .. just because the deployit
      # rest interface is soo bloody crap
      return passwordHash[2..-2]

  end

end