# frozen_string_literal: true

require_relative '../app/views/ruby_curses'
require_relative '../app/sources/google_suggest'

class Config
  attr_reader :view
  attr_reader :source

  def initialize
    @view   = RubyCurses.new
    @source = GoogleSuggest.new
  end
end
