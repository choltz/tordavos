# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/utils'

class UtilsTest < Minitest::Test
  def test_log
    File.open("#{Utils.root}/log/test.log", 'w') { |file| file.write '' }
    Utils.log('test log', "#{Utils.root}/log/test.log")

    results = File.read("#{Utils.root}/log/test.log")
    assert_equal "test log\n", results
  end

  def test_numeric
    assert_equal true, Utils.numeric?('100')
    assert_equal false, Utils.numeric?('abc')
    assert_equal false, Utils.numeric?('100abc')
    assert_equal false, Utils.numeric?(nil)
    assert_equal false, Utils.numeric?('')
  end
end
