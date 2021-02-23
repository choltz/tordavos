require 'curses'
require 'httparty'
require 'byebug'
require_relative 'lib/utils'

class CursesLoop
  include Curses

  def initialize
    init_screen
    start_color
    curs_set(0)
    noecho
    init_pair(1, 1, 0)
  end

  def event_loop
    begin
      win       = Curses::Window.new(0, 0, 1, 2)
      query     = ''
      character = ''

      # x = Curses.cols / 2  # We will center our text
      # y = Curses.lines / 2

      loop do
        win.setpos(0,0)

        win.attron(color_pair(1)) {
          win << "> #{query} "
        }

        # matches
        response = HTTParty.get"http://suggestqueries.google.com/complete/search?client=chrome&hl=en&gl=us&q=#{query}"
        results  = JSON.parse(response.body)[1].join("\n")

        win.setpos(1,0)
        win << results

        clrtoeol
        win << "\n"

        (win.maxy - win.cury).times {win.deleteln()}
        win.refresh

        character = win.getch.to_s

        if character == '127'
          query = query[0, query.length - 1]
        else
          query << character
        end

      end
    ensure
      close_screen
    end
  end
end
