# frozen_string_literal: true

require 'curses'
require_relative '../app/views/ruby_curses'
require_relative '../app/sources/google_suggest'

module Config
  class Application
    attr_reader :env,
                :source,
                :view

    def initialize
      @env    = :production
      @view   = RubyCurses.new(Curses)
      @source = GoogleSuggest.new
    end
  end
end
