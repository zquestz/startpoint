require 'test_helper'

class PasswordResetsControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  test "anonymous should get new" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      get :new
      assert_response :success
    end
  end
  
  test "logged in should not get new" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      UserSession.create(users(:admin))
      get :new
      assert_redirected_to root_path
      assert_not_nil flash[:error]
    end
  end
  
  test "anonymous should create password reset request" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      post :create, :email => users(:admin)[:email]
      assert_redirected_to root_path
      assert_not_nil flash[:notice]
    end
  end
  
  test "anonymous should not create invalid password reset request (invalid email)" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      post :create, :email => 'dont@exist.com'
      assert_response :success
      assert_not_nil flash[:error]
    end
  end
  
  test "anonymous should not create invalid password reset request (regexp failed)" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      post :create, :email => 'baddaddy'
      assert_response :success
      assert_not_nil flash[:error]
    end
  end
  
  test "logged in should not create password reset request" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      UserSession.create(users(:admin))
      post :create, :email => users(:admin)[:email]
      assert_redirected_to root_path
      assert_not_nil flash[:error]
    end
  end
  
  test "anonymous should get edit" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      get :edit, :id => users(:admin)[:perishable_token]
      assert_response :success
    end
  end
  
  test "anonymous should not get edit with bad perishable_token" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      get :edit, :id => 'bad_token'
      assert_redirected_to root_path
      assert_not_nil flash[:error]
    end
  end
  
  test "logged in should not get edit" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      UserSession.create(users(:admin))
      get :edit, :id => users(:admin)[:perishable_token]
      assert_redirected_to root_path
      assert_not_nil flash[:error]
    end
  end
  
  test "anonymous should update password reset request" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      put :update, :id => users(:admin)[:perishable_token], :user => {
        :password => 'password', 
        :password_confirmation => 'password'
      }
      assert_redirected_to user_path(users(:admin))
      assert_not_nil flash[:notice]
    end
  end
  
  test "anonymous should not update password reset request with bad perishable_token" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      put :update, :id => 'bad_token', :user => {
        :password => 'password', 
        :password_confirmation => 'password'
      }
      assert_redirected_to root_path
      assert_not_nil flash[:error]
    end
  end

  test "anonymous should not update invalid password reset request" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      put :update, :id => users(:admin)[:perishable_token], :user => {
        :password => '', 
        :password_confirmation => ''
      }
      assert_response :success
      assert_not_nil flash[:error]
    end
  end
  
  test "logged in should not update password reset request" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      UserSession.create(users(:admin))
      put :update, :id => users(:admin)[:perishable_token]
      assert_redirected_to root_path
      assert_not_nil flash[:error]
    end
  end
  
end
