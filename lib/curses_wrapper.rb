require 'curses'

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
    @window.keypad true
  end

  # Public Main event loop for this app. Collect entered text and hand control
  # to the caller to decide what to do with it.
  def event_loop
    begin
      query    = ''
      char     = ''
      selected = nil

      # x = Curses.cols / 2  # We will center our text
      # y = Curses.lines / 2

      loop do
        @window.setpos(0,0)

        @window.attron(color_pair(1)) { # red
          @window << "> #{query} "
        }

        results = yield @window, query
        results = results.respond_to?(:call) ? results.call : results

        self.write_results results, selected
        self.window_cleanup

        # Capture the next char
        char = @window.getch

        # close_screen
        if char == 263 # backspace
          query = query[0, query.length - 1]
        elsif char == 10 # enter
          @selection = query
          break
        elsif char == Curses::Key::DOWN
          selected = selected.nil? ? 0 : selected + 1
        elsif char == Curses::Key::UP
          selected = selected.nil? ? 0 : selected - 1
        elsif char == 27 # esc
          break
        else
          query << char
        end
      end
    ensure
      close_screen
    end
  end

  private

  # Internal: Write results to the window.
  def write_results(results, selected)
    @window.setpos(1,0)

    if selected.nil?
      results = results.map{ |result| "  #{result}" }
                       .join("\n")
    else
      results = results.map.with_index { |result, index|
        if selected == index
          " *#{result}"
        else
          "  #{result}"
        end
      }.join("\n")

      # results1 = results[0, selected].map{ |result| " #{result}" }.join("\n")
      # results2 = results[selected + 1, results.length].map{ |result| " #{result}" }.join("\n")
      # selected_results = "\n***#{results[selected, 1].first}                             \n"
      # results = results1 + selected_results + results2
    end
    # @window.attron(color_pair(1)) { # red

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
