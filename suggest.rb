require 'byebug'
require 'httparty'

class Suggest
  def initialize
    print '> '
  end

  def event_loop
    query = ''

    loop do
      input = listen

      if input == "\u007F"
        query = query[0, query.length - 1]
      else
        query << input
      end

      response = HTTParty.get"http://suggestqueries.google.com/complete/search?client=chrome&hl=en&gl=us&q=#{query}"
      results = JSON.parse(response.body)[1]

      puts "\e[H\e[2J"
      puts query
      puts '--------------------'
      puts results

      # print input.chr

      break if input =~ /\n|\r/

    end

    puts
    puts query
  end

  private

  def listen
    begin
      system('stty raw -echo')
      input = STDIN.getc
    ensure
      system('stty -raw echo')
    end

    input
  end
end


Suggest.new.event_loop

# p str.chr
