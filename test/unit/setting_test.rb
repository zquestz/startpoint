require 'test_helper'

class SettingTest < ActiveSupport::TestCase

  test "should load settings" do
    Setting.app_settings
    assert_not_nil Thread.current[:settings]
  end
  
end