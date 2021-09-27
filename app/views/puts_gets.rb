require_relative '../../lib/utils'

# Public: Handle terminal emulator display logic.
class PutsGets

  def initialize
    @query_update_callback = nil
  end

  def query_update_callback(&block)
    @query_update_callback = block
  end

  def event_loop
    query = ''

    loop do
      results = @query_update_callback.call char: nil, query: query
      input   = listen

      if input == "\u007F" # backspace
        query = query[0, query.length - 1]
      else
        query << input
      end

      puts "\e[H\e[2J"
      puts "Run: #{query}"
      puts '--------------------'
      puts results[0,10]

      # print input.chr

      break if input =~ /\n|\r/
    end

    puts
    puts query
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
end
