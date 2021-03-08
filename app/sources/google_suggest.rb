# frozen_string_literal: true

require          'httparty'
require_relative '../../lib/utils'

# Public: Query the Google suggest endpoint with the given query.
class GoogleSuggest
  URL = ->(query) { "http://suggestqueries.google.com/complete/search?client=chrome&hl=en&gl=us&q=#{query}" }

  # Public: Retrieve query results from Google suggest.
  #
  # query - String passed to Google Suggest for a set of related results.
  #
  # Returns and array of strings.
  def data(query)
    response = HTTParty.get URL.call query
    parsed   = JSON.parse(response.body)

    parsed.nil? ? [] : parsed[1]
  end
end
