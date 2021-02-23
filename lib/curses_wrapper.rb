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
  end

  # Public Main event loop for this app. Collect entered text and hand control
  # to the caller to decide what to do with it.
  def event_loop
    begin
      window    = Curses::Window.new(0, 0, 1, 2)
      query     = ''
      character = ''

      # x = Curses.cols / 2  # We will center our text
      # y = Curses.lines / 2

      loop do
        window.setpos(0,0)

        window.attron(color_pair(1)) { # red
          window << "> #{query} "
        }

        results = yield(window, query)
        results = results.map{ |result| "  #{result}" }
                         .join("\n")

        window.setpos(1,0)
        window << results
        clrtoeol
        window << "\n"

        (window.maxy - window.cury).times {window.deleteln()}
        window.refresh

        character = window.getch.to_s

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
end
