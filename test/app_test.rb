# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../app.rb'
require_relative '../config/test'

class AppTest < Minitest::Test
  def test_instantiate_app_object
    config = Config::Test.new
    app    = App.new config

    assert_equal 'App', app.class.name
  end

  def test_event_loop_initialization
    config = Config::Test.new
    app    = App.new config

    app.start
    assert_equal true, app.test_event_loop
  end
end
