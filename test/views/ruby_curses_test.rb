# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../app/views/ruby_curses'
require_relative '../mocks/mock_ruby_curses'

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

  def test_terminate
    mock        = MockRubyCurses
    ruby_curses = RubyCurses.new(mock)

    mock.clear_methods
    ruby_curses.terminate

    assert_equal [:close_screen], mock.method_results
  end
end
