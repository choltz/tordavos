# frozen_string_literal: true

require_relative 'lib/utils'

# Public: This a controller in as much as it is the glue between the display
# code (view) and the data source (model). That is where the similarity to MVC
# frameworks end.
#
# Rather than define route end points, this class runs two event loops: one
# listens for user input from the display view object and then other listens
# for data queries run against the user input.
class App
  attr_reader :test_event_loop

  # Constructor: Establish instance variables and app configuration.
  def initialize(config)
    @config      = config
    @query       = ''
    @results     = []

    # Register view event listener
    @config.view.add_event_listener('key-press') do |char|
      @query = @config.key_handler.on_key_press char:  char,
                                                query: @query
    end
  end

  def start
    data_source_event_loop
    # view_event_loop

    if @config.env == :test
      @test_event_loop = true
    end
  end

  private

  # Internal: Start a separate thread to query the data source for results.
  def data_source_event_loop
    Thread.new do
      old_query = ''

      loop do
        query = @query.dup

        if query != old_query
          @results = @config.source.data(query)
          old_query = query
        end

        break if @config.env == :test # unit tests get one loop iteration

        sleep 0.5
      end
    end

    # Public: Listen for user input and start of a Thread that
    # returns a result set based on that input.
    # def view_event_loop
    #   char     = ''
    #   old_char = nil

    #   loop do
    #     char = @config.view.input || ''

    #     @config.view.render query: @query, results: @results

    #     if char != old_char
    #       old_char = char.dup
    #       @query   = @config.key_handler.on_key_press char:  char,
    #                                                   query: @query
    #     end

    #     break if @config.env == :test # unit tests get one loop iteration

    #     sleep 0.05 # don't let this loop spike the CPU.
    #   end
    # ensure
    #   @config.view.terminate
    # end
  end
end
