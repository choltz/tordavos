# frozen_string_literal: true

require          'curses'
require_relative '../../lib/utils'
require_relative '../../app/views/ruby_curses'
require_relative '../../app/sources/google_suggest'

# Public: This a controller in as much as it is the glue between the display
# code (view) and the data source (model). That is where the similarity to MVC
# frameworks end.
#
# Rather than define route end points, this class runs two event loops: one
# listens for user input from the display view object and then other listens
# for data queries run against the user input.
class Application
  include Curses

  def initialize
    @view    = RubyCurses.new
    @query   = ''
    @results = []
  end

  def start
    data_source_event_loop
    view_event_loop
  end

  private

  # Internal: Start a separate thread to query the data source for results.
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

    # Public: Listen for user input and start of a Thread that
    # returns a result set based on that input.
    def view_event_loop
      char     = ''
      old_char = nil
      # selected = nil

      loop do
        char = @view.input || ''
        @view.render query: @query, results: @results

        if char != old_char
          old_char = char.dup

          @query = key_handler char, @query
        end

        sleep 0.05 # don't let this loop spike the CPU.
      end
    ensure
      Curses.close_screen
    end
  end

  # Internal: Handle user input - perform specialized actions based on input.
  #
  # char - Character typed by user.
  def key_handler(char, query)
    return if char.nil?

    if char == 127 # backspace
      query[0, query.length - 1]
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
      query.dup << char
    end
  end
end
