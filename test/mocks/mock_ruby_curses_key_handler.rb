require 'curses'

class MockRubyCursesKeyHandler
  include Curses

  attr_accessor :input,
                :method_results

  def initialize
    @method_results = []
  end

  def on_key_press(char:, query:)

  end
end
