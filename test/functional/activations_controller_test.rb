require 'test_helper'

class ActivationsControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  test "anonymous with correct token should activate user" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      get :create, :activation_code => users(:admin)[:perishable_token]
  
      assert_redirected_to root_path
      assert_not_nil flash[:notice]
    end
  end
  
  test "anonymous with incorrect token should not activate user" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      get :create, :activation_code => 'broken'
  
      assert_redirected_to root_path
      assert_not_nil flash[:error]
    end
  end
  
  test "logged in should not activate user" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      UserSession.create(users(:admin))
      get :create, :activation_code => users(:admin)[:perishable_token]
  
      assert_redirected_to root_path
      assert_not_nil flash[:error]
    end
  end

end
