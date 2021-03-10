# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../app/views/ruby_curses'

class RubyCursesTest < Minitest::Test
  def test_initialization
    mock = MockRubyCurses
    mock.clear_methods

    RubyCurses.new(mock)

    expected = [:init_screen, :start_color, :curs_set, :noecho, :init_pair, :init_pair, :stdscr]
    assert_equal expected, mock.method_results
  end

  def test_input
    mock = MockRubyCurses

    ruby_curses = RubyCurses.new(mock)
    mock.clear_methods

    ruby_curses.input

    assert_equal [:stdscr], mock.method_results
  end

  def test_render
    mock        = MockRubyCurses
    ruby_curses = RubyCurses.new(mock)

    mock.clear_methods
    ruby_curses.render(query: 'query', results: [])

    assert_equal [:clrtoeol], mock.method_results
  end

  class MockRubyCurses
    # Public: Mock curses render object.
    #
    # Notes: It's hard to test the side-effects of the curses-based renderer.
    # To get some semblance of testing in place, this mock object collects all
    # Curses calls in sequence. The tests can then validate the methods called.
    class << self
      attr_accessor :methods

      def clear_methods
        @methods = []
      end

      # Public: collect method calls and save them to an array.
      def method_missing(method, *params, **args)
        @methods = [] if @methods.nil?
        @methods << method
      end

      # Public: Return the list of methods called.
      def method_results
        @methods
      end

      # Public: Mock method that doesn't fit the method_missing approach.
      def stdscr
        @methods << :stdscr
        OpenStruct.new nodelay: nil
      end
    end

    # Public: Mock object call withing the Renderer.
    class Window
      attr_accessor :methods

      def initialize(*args)
        @methods = []
      end

      # Public: collect method calls and save them to an array.
      def method_missing(method, *params, **args)
        @methods = [] if @methods.nil?
        @methods << method

        if method == :cury
          0
        elsif method == :maxy
          0
        end
      end

      def attron(arg, &block)
        block.call
      end
    end
  end
end
