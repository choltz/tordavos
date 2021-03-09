# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../app/sources/google_suggest'

class GoogleSuggestTest < Minitest::Test
  def test_responds_to_data_method
    source = GoogleSuggest.new

    assert source.respond_to?(:data)
  end
end
