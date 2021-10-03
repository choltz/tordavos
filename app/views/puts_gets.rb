require_relative '../../lib/utils'

# Public: Handle terminal emulator display logic.
class PutsGets
  attr_accessor :last_updated,
                :query,
                :results

  def initialize
    @query   = ''
    @results = []
  end

  def input_loop
    # query = ''

    loop do
      # results = @query_update_callback.call char: nil, query: query
      # results = []

      # puts "\e[H\e[2J"
      puts `clear`
      puts "Run: #{@query}"
      puts '--------------------'
      puts @results[0,10]

      input = listen
      @last_updated = DateTime.now

      if input == "\u007F" # backspace
        @query = @query[0, query.length - 1]
      else
        @query << input
      end

      # print input.chr

      break if input =~ /\n|\r/
    end

    puts
    puts @query
  end

  def listen
    begin
      system('stty raw -echo')
      input = STDIN.getc
    ensure
      system('stty -raw echo')
    end

    input
  end

  # def hide_cursor
  #   system 'tput civis'
  # end

  # def show_cursor
  #   system 'tput cnorm'
  # end
end
