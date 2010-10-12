require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  setup :activate_authlogic

  test "anonymous should not get index" do
    if Setting.maintenance == false
      get :index
      assert_redirected_to new_user_session_path
      assert_not_nil flash[:error]
    end
  end
  
  test "logged in should not get index" do
    if Setting.maintenance == false
      UserSession.create(users(:regular))
      get :index
      assert_redirected_to root_path
      assert_not_nil flash[:error]
    end
  end
  
  test "admin should get index" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      get :index
      assert_response :success
      assert_not_nil assigns(:page)
    end
  end
  
end
