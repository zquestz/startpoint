require 'test_helper'

class MainControllerTest < ActionController::TestCase
  setup :activate_authlogic

  test "everyone should get main" do
    if Setting.maintenance == false
      get :index
      assert_response :success
      assert_not_nil assigns(:page)
    end
  end
  
  test "everyone should get maintenance" do
    get :maintenance
    assert_response :success
  end

end
