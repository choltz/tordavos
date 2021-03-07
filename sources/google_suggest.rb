require          'httparty'
require_relative '../lib/utils'

# Public: Google suggest data source.
class GoogleSuggest
  URL = ->(query) { "http://suggestqueries.google.com/complete/search?client=chrome&hl=en&gl=us&q=#{query}" }

  # Public: Retrieve query results from Google suggest.
  #
  # query - String passed to Google Suggest for a set of related results.
  #
  # Returns and array of strings.
  def data(query)
    response = HTTParty.get URL.call query
    JSON.parse(response.body)[1]
  end
end
