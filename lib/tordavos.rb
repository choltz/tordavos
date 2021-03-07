require          'httparty'
require          'curses'
require_relative 'utils'
require_relative './curses_wrapper.rb'

class Tordavos
  include Curses

  def initialize
    init_screen
    start_color
    curs_set(0)
    noecho
    init_pair(1, 1, 0)

    @window = Curses::Window.new(0, 0, 1, 2)
    @window.keypad true
    @query = ''
    @results = []

    # spin off a fiber that looks at @query and gets a list of responses
    self.start_suggest_thread
  end

  GOOGLE_SUGGEST_URL = ->(query) { "http://suggestqueries.google.com/complete/search?client=chrome&hl=en&gl=us&q=#{query}" }

  def event_loop
    begin
      char     = ''
      selected = nil

      loop do
        @window.setpos(0,0)

        @window.attron(color_pair(1)) { # red
          @window << "> #{@query} "
        }

        # results = yield @window, query
        # results = results.respond_to?(:call) ? results.call : results
        self.write_results selected

        self.window_cleanup

        # Capture the next char
        char = @window.getch

        # close_screen
        if char == 263 # backspace
          @query = @query[0, @query.length - 1]
        elsif char == 10 # enter
          @selection = @query
          break
        elsif char == Curses::Key::DOWN
          selected = selected.nil? ? 0 : selected + 1
        elsif char == Curses::Key::UP
          selected = selected.nil? ? 0 : selected - 1
        elsif char == 27 # esc
          break
        else
          @query << char
        end
      end
    ensure
      close_screen
    end
  end

  def start_suggest_thread
    Thread.new do
      loop do
        response = HTTParty.get GOOGLE_SUGGEST_URL.call @query
        @results =  JSON.parse(response.body)[1]

        sleep 0.25
      end
    end
  end

  # a bit of cleanup for each time round the loop
  def window_cleanup
    clrtoeol
    @window << "\n"
    (@window.maxy - @window.cury).times { @window.deleteln() }
    @window.refresh
  end

  # Internal: Write results to the window.
  def write_results(selected)
    @window.setpos(1,0)

    if selected.nil?
      output = @results.map{ |result| "  #{result}" }
                       .join("\n")
    else
      output = @results.map.with_index { |result, index|
        if selected == index
          " *#{result}"
        else
          "  #{result}"
        end
      }.join("\n")
    end

    @window << output
  end
end
