require 'curses'
require 'byebug'

class CursesWrapper
  include Curses

  attr_accessor :selection

  def initialize
    init_screen
    start_color
    curs_set(0)
    noecho
    init_pair(1, 1, 0)

    @window = Curses::Window.new(0, 0, 1, 2)
  end

  # Public Main event loop for this app. Collect entered text and hand control
  # to the caller to decide what to do with it.
  def event_loop
    begin
      query     = ''
      character = ''

      # x = Curses.cols / 2  # We will center our text
      # y = Curses.lines / 2

      loop do
        @window.setpos(0,0)

        @window.attron(color_pair(1)) { # red
          @window << "> #{query} "
        }

        results = yield @window, query

        self.write_results results.respond_to?(:call) ? results.call : results
        self.window_cleanup

        # Capture the next character
        character = @window.getch.to_s

        if character == '127'
          query = query[0, query.length - 1]
        elsif character == '10'
          @selection = query
          break
        elsif character == '27'
          break
        else
          query << character
        end
      end
    ensure
      close_screen
    end
  end

  private

  # Internal: Write results to the window.
  def write_results(results)
    @window.setpos(1,0)

    results = results.map{ |result| "  #{result}" }
      .join("\n")

    @window << results
  end

  # a bit of cleanup for each time round the loop
  def window_cleanup
    clrtoeol
    @window << "\n"
    (@window.maxy - @window.cury).times { @window.deleteln() }
    @window.refresh
  end
end
