# frozen_string_literal: true

class Utils
  # Public: Return true if the given object is nil or an empty string.
  def self.blank?(object)
    object.nil? || object == ''
  end

  def self.log(text = '', path = "#{Utils.root}/log/debug.log")
    File.open(path, 'a') do |file|
      file.write "#{text}\n"
    end
  end

  def self.numeric?(value)
    Float(value) != nil rescue false
  end

  def self.root
   path  = File.dirname(__FILE__)
   array = path.split('/')

   array.pop
   array.join('/')
  end
end
