# frozen_string_literal: true

require_relative '../../lib/utils'
require_relative '../../lib/net_request'

# Public: Query the Google suggest endpoint with the given query.
class GoogleSuggest
  attr_accessor :query,
                :results

  URL = ->(query) { "http://suggestqueries.google.com/complete/search?client=chrome&hl=en&gl=us&q=#{query}" }

  # Constructor: Initialize object with dependencies.
  #
  # net_request - Dependecy injected object used to make http(s) calls.
  def initialize(net_request = NetRequest.new)
    @net_request = net_request
    @query       = ''
    @old_query   = ''
    @results     = []

    self.process_query
  end

  # Public: Retrieve query results from Google suggest.
  #
  # query - String passed to Google Suggest for a set of related results.
  #
  # Returns and array of strings.
  def process_query
    Thread.new do
      loop do
        if @old_query != @query
          response = @net_request.get URL.call @query
          parsed   = JSON.parse(response.body)
          @results = parsed.nil? ? [] : parsed[1]

          Utils.log @query

          @old_query = @query.dup
        end

        sleep 0.5
      end
    end

    # Thread.new do
    #   response     = @net_request.get URL.call query
    #   parsed       = JSON.parse(response.body)
    #   self.results = parsed.nil? ? [] : parsed[1]
    # end
  end
end
