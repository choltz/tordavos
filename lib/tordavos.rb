require          'curses'
require_relative 'utils'
require_relative 'display'
require_relative '../sources/google_suggest'

# Main app class.
class Tordavos
  include Curses

  def initialize
    @display = Display.new
    @query   = ''
    @results = []

    data_source_event_loop
  end

  # Public: Listen for user input and start of a Thread that
  # returns a result set based on that input.
  def event_loop
    char     = ''
    old_char = nil
    # selected = nil

    loop do
      char = @display.input || ''
      @display.render query: @query, results: @results

      if char != old_char
        old_char = char.dup

        key_handler char
      end

      sleep 0.05 # don't let this loop spike the CPU.
    end
  ensure
    Curses.close_screen
  end

  def data_source_event_loop
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

  private

  # Internal: Handle user input - perform specialized actions based on input.
  #
  # char - Character typed by user.
  def key_handler(char)
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
end
