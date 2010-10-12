require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  test "anonymous should access new user_session" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
       get :new

       assert_response :success
     end
  end
  
  test "logged in should not access new user_session" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
       UserSession.create(users(:admin))
       get :new

       assert_redirected_to root_path
       assert_not_nil flash[:error]
     end
  end
  
  test "anonymous with credentials should create user_session" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      post :create, :user_session => { :login => 'admin', :password => 'password'}
  
      assert_redirected_to root_path
      assert_not_nil flash[:notice]
    end
  end
  
  test "anonymous without credentials should not create user_session" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      post :create, :user_session => { :login => 'admin', :password => 'wrongpassword'}
  
      assert_response :success
    end
  end
  
  test "logged in should not create user_session" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      UserSession.create(users(:admin))
      post :create, :user_session => { :login => 'admin', :password => 'password'}
  
      assert_redirected_to root_path
      assert_not_nil flash[:error]
    end
  end
  
  test "anonymous should not destroy user_session" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      delete :destroy, :id => users(:admin).to_param
  
      assert_redirected_to new_user_session_path
      assert_not_nil flash[:error]
    end
  end

  test "logged in should destroy user_session" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      UserSession.create(users(:admin))
      delete :destroy, :id => users(:admin).to_param
  
      assert_redirected_to root_path
      assert_not_nil flash[:notice]
    end
  end

end
