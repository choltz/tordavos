# frozen_string_literal: true

require 'curses'
require_relative '../test/mocks/mock_ruby_curses'

module Config
  class Test
    attr_reader :env,
                :source,
                :view

    def initialize
      @env    = :test
      @view   = MockRubyCurses.new
      @source = OpenStruct.new
    end
  end
end
