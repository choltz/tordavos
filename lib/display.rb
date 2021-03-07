require 'curses'

class Display
  include Curses

  attr_accessor :window

  def initialize
    Curses.init_screen
    Curses.start_color
    Curses.curs_set(0)
    Curses.noecho
    Curses.init_pair(COLOR_BLUE,COLOR_BLUE,COLOR_BLACK)
    Curses.init_pair(COLOR_RED,COLOR_RED,COLOR_BLACK)
    Curses.stdscr.nodelay = 1

    @window = Curses::Window.new(0, 0, 1, 2)
  end

  def show_input_query(query)
    @window.setpos(0,0)
    @window.attron(color_pair(COLOR_RED) | A_NORMAL) {
      @window << "> #{query}"
    }

    @window << '| '
  end

  # Internal: Write results to the window.
  def show_results(results, selected)
    @window.setpos(1,0)

    if selected.nil?
      output = results.map{ |result| "  #{result}" }
                      .join("\n")
    else
      output = results.map.with_index { |result, index|
        if selected == index
          " *#{result}"
        else
          "  #{result}"
        end
      }.join("\n")
    end

      @window << output
  end

  # a bit of cleanup for each time round the loop
  def window_cleanup
    Curses.clrtoeol
    @window << "\n"
    (@window.maxy - @window.cury).times { @window.deleteln() }
    @window.refresh
  end
end
