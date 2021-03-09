# frozen_string_literal: true

require_relative '../../lib/utils'
require_relative '../../lib/net_request'

# Public: Query the Google suggest endpoint with the given query.
class GoogleSuggest
  URL = ->(query) { "http://suggestqueries.google.com/complete/search?client=chrome&hl=en&gl=us&q=#{query}" }

  # Constructor: Initialize object with dependencies.
  #
  # net_request - Dependecy injected object used to make http(s) calls.
  def initialize(net_request = NetRequest.new)
    @net_request = net_request
  end

  # Public: Retrieve query results from Google suggest.
  #
  # query - String passed to Google Suggest for a set of related results.
  #
  # Returns and array of strings.
  def data(query)
    response = @net_request.get URL.call query
    parsed   = JSON.parse(response.body)

    parsed.nil? ? [] : parsed[1]
  end
end
