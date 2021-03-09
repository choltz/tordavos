# frozen_string_literal: true
require 'httparty'

# Public: Simple wrapper around http(s) requests. This will make it easier to
# interchange net request logic.
class NetRequest
  def initialize(request_library = HTTParty)
    @request_library = request_library
  end

  # Public: make a GET request with the given URL path.
  #
  # path - Target URL for request.
  #
  # Returns a response.
  def get(path)
    @request_library.get path
  end
end
