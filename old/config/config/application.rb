# frozen_string_literal: true

require 'curses'
require_relative '../app/views/ruby_curses'
require_relative '../app/views/ruby_curses_key_handler'
require_relative '../app/sources/google_suggest'

module Config
  class Application
    attr_reader :env,
                :key_handler,
                :source,
                :view

    def initialize
      @env         = :production
      @key_handler = RubyCursesKeyHandler.new(Curses)
      @view        = RubyCurses.new(renderer: Curses, config: self)
      @source      = GoogleSuggest.new
    end
  end
end
