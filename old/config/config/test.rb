# frozen_string_literal: true

require 'curses'
require_relative '../test/mocks/mock_ruby_curses'
require_relative '../test/mocks/mock_ruby_curses_key_handler'
require_relative '../test/mocks/mock_data_source'

module Config
  class Test
    attr_reader :env,
                :key_handler,
                :source,
                :view

    def initialize
      @env         = :test
      @key_handler = MockRubyCursesKeyHandler.new
      @view        = MockRubyCurses.new
      @source      = MockDataSource.new
    end
  end
end
