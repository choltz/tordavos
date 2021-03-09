# frozen_string_literal: true

require 'curses'
require_relative '../app/views/ruby_curses'
require_relative '../app/sources/google_suggest'

class Config
  attr_reader :source,
              :view

  def initialize
    @view   = RubyCurses.new(Curses)
    @source = GoogleSuggest.new
  end
end
