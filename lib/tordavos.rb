require          'httparty'
require          'curses'
require_relative 'utils'
require_relative 'display'
require_relative '../sources/google_suggest.rb'

class Tordavos
  include Curses

  def initialize
    @display = Display.new
    @query   = ''
    @results = []

    # spin off a fiber that looks at @query and gets a list of responses
    self.start_suggest_thread
  end

  def event_loop
    begin
      char     = ''
      old_char = nil
      # selected = nil

      loop do
        char = @display.input

        @display.show_input_query(@query)
        # @display.show_results @results, selected
        @display.show_results @results
        @display.window_cleanup

        if char != old_char
          old_char = char.dup

          if char == 127 # backspace
            @query = @query[0, @query.length - 1]
          # elsif char == 10 # enter
          #   @selection = @query
          #   break
          # elsif char == Curses::Key::DOWN
          #   selected = selected.nil? ? 0 : selected + 1
          # elsif char == Curses::Key::UP
          #   selected = selected.nil? ? 0 : selected - 1
          # elsif char == 27 # esc
          #   break
          else
            @query << char if !char.nil?
          end
        end

        sleep 0.05 # don't let this loop spike the CPU.
      end
    ensure
      Curses.close_screen
    end
  end

  def start_suggest_thread
    Thread.new do
      old_query = ''
      source    = GoogleSuggest.new

      loop do
        query = @query.dup

        if query != old_query
          @results = source.data(query)
          old_query = query
        end

        sleep 0.5
      end
    end
  end
end
