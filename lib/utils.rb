class Utils
  def self.numeric?(value)
    Float(value) != nil rescue false
  end

  def self.first
    ->(array) { array.first }
  end

  def self.url_get
    httparty_get = ->(url) { HTTParty.get url }

    httparty_get >> self.json_parse
  end

  def self.json_parse
    ->(response) { JSON.parse(response.body) }
  end

  def self.second
    ->(array) { array[1] }
  end

  def self.value(value)
    ->() { value }
  end
end
