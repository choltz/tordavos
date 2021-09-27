# frozen_string_literal: true

require 'curses'

# Public: Handle terminal emulator display logic.
class RubyCurses
  include Curses

  attr_accessor :window

  # Public: Constructor - initialize @renderer environment.
  def initialize(renderer: Curses, config: nil)
    @config    = config
    @renderer  = renderer
    @listeners = {}

    @renderer.init_screen
    @renderer.start_color
    @renderer.curs_set(0)
    @renderer.noecho
    @renderer.init_pair(COLOR_BLUE, COLOR_BLUE, COLOR_BLACK)
    @renderer.init_pair(COLOR_RED, COLOR_RED, COLOR_BLACK)
    @renderer.stdscr.nodelay = 1
    @renderer.stdscr.keypad = true

    @window = @renderer::Window.new(0, 0, 1, 2)

    self.event_loop
  end

  def add_event_listener(name, &block)
    @listeners[name] = block
  end

  # Public: Capture input data.
  def input
    @renderer.stdscr.getch
  end

  # Public: Render the complete view output - input query and results.
  # def render(query:, results:)
  def render(query:)
    show_input_query(query)
    # show_results results
    show_results
    window_cleanup
  end

  # Public: Finish out the UI session.
  def terminate
    @renderer.close_screen
  end

  private

  # Public: Listen for user input and start of a Thread that
  # returns a result set based on that input.
  def event_loop
    char     = ''
    old_char = nil

    loop do
      char = self.input || ''

      # self.render query: @query, results: @results
      self.render query: @query

      if char != old_char
        old_char = char.dup

        (@listeners['key-press'] || []).each do |block|
          block.call char
        end
      end

      break if @config.env == :test # unit tests get one loop iteration

      sleep 0.05 # don't let this loop spike the CPU.
    end
  ensure
    self.terminate
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
  # def show_results(results)
  def show_results
    @window.setpos(1,0)

    # if selected.nil?

      # output = results.map{ |result| "  #{result}" }
                      # .join("\n")

    output = 'Buh'

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

  # Internal:  A bit of cleanup for each time round the loop
  def window_cleanup
    @renderer.clrtoeol
    @window << "\n"
    (@window.maxy - @window.cury).times { @window.deleteln() }
    @window.refresh
  end
end
