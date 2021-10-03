# frozen_string_literal: true

require 'curses'

# Public: Handle terminal emulator display logic.
class RubyCursesKeyHandler
  include Curses

  attr_accessor :selection

  # Public: Constructor - initialize @renderer environment.
  def initialize(renderer = Curses)
    @renderer = renderer
  end

  def on_key_press(char:, query:)
    return if char.nil?

    if char == 127 # backspace
      query = query[0, query.length - 1]
    # elsif char == 10 # enter
    #   @selection = @query
    #   break
    elsif char == Curses::Key::DOWN
      @selection = @selection.nil? ? 0 : @selection + 1
    elsif char == Curses::Key::UP
      @selection = @selection.nil? ? 0 : @selection - 1
    elsif char == 27 # esc
      # break
    else
      query = query.dup << char
    end

    query
  end
end
