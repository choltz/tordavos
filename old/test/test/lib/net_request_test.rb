# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/net_request'

class NetRequestTest < Minitest::Test
  def test_get
    net_request = NetRequest.new(MockNetRequest)
    results     = net_request.get 'some_path'

    assert_equal 'results', results
  end

  class MockNetRequest
    def self.get(path)
      'results'
    end
  end
end
