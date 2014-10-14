class ConfigurationItem
  attr_accessor :id, :type, :properties

  def initialize(type, id)
    @type = type
    @id = id
    @properties = {}
  end

  def [](propertyname)
    @properties[propertyname]
  end

  def []=(propertyname, value)
    @properties[propertyname]=value
  end

  def name
    @id.split('/')[-1]
  end

  def to_s
    "CI: '#{@id}' '#{@type}' #{@properties.map{|k,v| "#{k}=#{v}"}.join(', ')}"
  end

end