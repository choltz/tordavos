require          'httparty'
require_relative 'utils'
require_relative './curses_wrapper.rb'

class Tordavos
  GOOGLE_SUGGEST_URL = ->(query) { "http://suggestqueries.google.com/complete/search?client=chrome&hl=en&gl=us&q=#{query}" }

  def self.listen(curses)
    curses.event_loop do |win, query|
      Utils.value(query) >>
      GOOGLE_SUGGEST_URL >>
      Utils.url_get      >>
      Utils.second
    end

    puts curses.selection
  end
end
