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

    # view = RubyCurses.new
    hide_cursor
    view = PutsGets.new
    view.query_update_callback(&method(:on_query_update))
    view.event_loop
  ensure
    show_cursor
  end

  private

  def hide_cursor
    system 'tput civis'
  end

  def on_query_update(char:, query:)
    @query = query
    @source.query = query

    @source.results
  end

  def show_cursor
    system 'tput cnorm'
  end
end
