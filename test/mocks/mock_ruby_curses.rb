class MockRubyCurses
  attr_accessor :input

  def render(*args)
  end

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
