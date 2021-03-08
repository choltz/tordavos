# frozen_string_literal: true

require 'curses'

# Public: Handle terminal emulator display logic.
class Display
  include Curses

  attr_accessor :window

  # Public: Constructor - initialize Curses environment.
  def initialize
    Curses.init_screen
    Curses.start_color
    Curses.curs_set(0)
    Curses.noecho
    Curses.init_pair(COLOR_BLUE, COLOR_BLUE, COLOR_BLACK)
    Curses.init_pair(COLOR_RED, COLOR_RED, COLOR_BLACK)
    Curses.stdscr.nodelay = 1

    @window = Curses::Window.new(0, 0, 1, 2)
  end

  def input
    Curses.stdscr.getch
  end

  # Public: Render the complete view output - input query and results.
  def render(query:, results:)
    show_input_query(query)
    show_results results
    window_cleanup
  end

  # Public: Show the query the user is inputting.
  def show_input_query(query)
    @window.setpos(0,0)
    @window.attron(color_pair(COLOR_RED) | A_NORMAL) {
      @window << "> #{query}"
    }

    @window << '| ' # simulated caret for now.
  end

  # Public: Write results to the window.
  def show_results(results)
    @window.setpos(1,0)

    # if selected.nil?
      output = results.map{ |result| "  #{result}" }
                      .join("\n")
    # else
    #   output = results.map.with_index { |result, index|
    #     if selected == index
    #       " *#{result}"
    #     else
    #       "  #{result}"
    #     end
    #   }.join("\n")
                    # end

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
