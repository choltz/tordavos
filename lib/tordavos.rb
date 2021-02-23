require 'httparty'
# require 'byebug'

require_relative './curses_wrapper.rb'

class Tordavos

  def self.listen
    curses = CursesWrapper.new

    curses.event_loop do |win, query|
      response = HTTParty.get"http://suggestqueries.google.com/complete/search?client=chrome&hl=en&gl=us&q=#{query}"
      JSON.parse(response.body)[1]
    end

    puts curses.selection
  end
end
