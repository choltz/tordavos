# frozen_string_literal: true

require_relative './app/views/ruby_curses'
require_relative './app/views/puts_gets'
require_relative './app/sources/google_suggest'
require_relative './app/sources/executables_in_path'
require_relative 'lib/utils'

class App
  def initialize
    @query    = ''
    @source   = GoogleSuggest.new
    # @source = ExecutablesInPath.new

    view = RubyCurses.new
    input_listener view, @source
    view.input_loop
  end

  private

  # Internal: Asynchronously check the view's current query, pass that along
  # to the source object and get the results. Throttle the loop so it doesn't
  # spike the cpu or make too many requests to the source. Only check the source
  # if the query has changed.
  def input_listener(view, source)
    old_query = ''

    Thread.new do
      loop do
        if old_query != view.query
          view.results = source.data(view.query)
          Utils.log(view.results)

          old_query = view.query
        end

        sleep(0.5)
      end
    end
  end
end
