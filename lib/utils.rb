class Utils
  def self.log(text = '')
    File.open("#{self.root}/log/debug.log", 'a') do |file|
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
