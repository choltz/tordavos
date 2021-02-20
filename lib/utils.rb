class Utils
  def self.numeric?(value)
    Float(value) != nil rescue false
  end
end
