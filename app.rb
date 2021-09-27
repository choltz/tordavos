# frozen_string_literal: true

require_relative './app/views/ruby_curses'
require_relative './app/sources/google_suggest'
require_relative './app/sources/executables_in_path'
require_relative 'lib/utils'

class App
  def initialize
    @query   = ''
    @results = ['buh', 'buh2']

    # @source   = GoogleSuggest.new
    @source   = ExecutablesInPath.new

    view = RubyCurses.new
    view.query_update_callback(&method(:on_query_update))
    view.event_loop
  end

  def on_query_update(char:, query:)
    @query = query

    @results = @source.data(query)
    @results
  end
end
