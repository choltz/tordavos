# frozen_string_literal: true

require_relative '../../lib/utils'

# Public: Query the Google suggest endpoint with the given query.
class ExecutablesInPath
  # Constructor
  def initialize
    @data = `/bin/bash -c "compgen -c"`.split("\n")
  end

  # Public: Filter the list of matches to the query given.
  #
  # query - String passed used to filter results.
  #
  # Returns and array of strings.
  def data(query)
    return @data if Utils.blank?(query)

    @data.filter { |d| d =~ /#{query}/ }.uniq
  end
end
