# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../app/sources/google_suggest'

class GoogleSuggestTest < Minitest::Test
  def test_responds_to_data_method
    source = GoogleSuggest.new MockNetRequest
    assert source.respond_to?(:data)
  end

  def test_returns_and_parses_google_suggest_data
    source   = GoogleSuggest.new MockNetRequest
    expected = ['tardis meaning', 'tardis blue', 'tardis interior', 'tardis dr who', 'tardis mod', 'tardis doctor who', 'tardis definition', 'tardis wiki']

    assert source.respond_to?(:data)
    assert_equal expected, source.data('query')
  end

  class MockNetRequest
    def self.get(_)
      data = [ 'tardis',
               ['tardis meaning', 'tardis blue', 'tardis interior', 'tardis dr who', 'tardis mod', 'tardis doctor who', 'tardis definition', 'tardis wiki'],
               ['', '', '', '', '', '', '', ''],
               [],
               { 'google:clientdata': { 'bpc': false, 'tlw': false },
                 'google:suggestrelevance': [601, 600, 555, 554, 553, 552, 551, 550],
                 'google:suggestsubtypes': [[433], [], [], [], [], [], [], []],
                 'google:suggesttype': ['QUERY', 'QUERY', 'QUERY', 'QUERY', 'QUERY', 'QUERY', 'QUERY', 'QUERY'],
                 'google:verbatimrelevance': 1300 }
             ]

      OpenStruct.new body: data.to_json
    end
  end
end
