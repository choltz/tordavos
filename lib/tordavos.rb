require          'httparty'
require          'curses'
require_relative 'utils'
require_relative './curses_wrapper.rb'

class Tordavos
  include Curses

  def initialize
    Curses.init_screen
    Curses.start_color
    Curses.curs_set(0)
    Curses.noecho
    Curses.init_pair(COLOR_BLUE,COLOR_BLUE,COLOR_BLACK)
    Curses.init_pair(COLOR_RED,COLOR_RED,COLOR_BLACK)

    Curses.stdscr.nodelay = 1

    @window = Curses::Window.new(0, 0, 1, 2)
    @window.keypad true
    @query = ''
    @results = []

    # spin off a fiber that looks at @query and gets a list of responses
    self.start_suggest_thread
  end

  def event_loop
    begin
      char     = ''
      old_char = nil
      selected = nil

      loop do
        # Capture the next char
        char = Curses.stdscr.getch

        @window.setpos(0,0)

        self.display_input_query
        self.display_results selected
        self.window_cleanup

        if char != old_char
          old_char = char.dup

          # close_screen
          if char == 127 # backspace
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
            @query << char if !char.nil?
          end
        end
      end
    ensure
      Curses.close_screen
    end
  end

  def start_suggest_thread
    url = ->(query) { "http://suggestqueries.google.com/complete/search?client=chrome&hl=en&gl=us&q=#{query}" }

    Thread.new do
      old_query = ''

      loop do
        query = @query.dup

        if query != old_query
          old_query = query
          response  = HTTParty.get url.call @query
          @results  = JSON.parse(response.body)[1]
          Utils.log(query)
        end

        sleep 0.5
      end
    end
  end

  # a bit of cleanup for each time round the loop
  def window_cleanup
    Curses.clrtoeol
    @window << "\n"
    (@window.maxy - @window.cury).times { @window.deleteln() }
    @window.refresh
  end

  def display_input_query
    @window.attron(color_pair(COLOR_RED) | A_NORMAL) { # red
      @window << "> #{@query}"
    }

    @window << '| '
  end

  # Internal: Write results to the window.
  def display_results(selected)
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
