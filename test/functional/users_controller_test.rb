require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  # Make sure maintenance mode redirect is working.
  test "maintenance mode" do
    if Setting.maintenance == true
      get :index
      assert_redirected_to maintenance_path
      assert_nil assigns(:users)
    end
  end
  
  # Make sure pages don't load when signup is turned off.
  test "signup mode disabled" do
    if ((Setting.maintenance == false) and (Setting.signup == false))
      get :index
      assert_redirected_to root_path
      assert_nil assigns(:users)
      assert_not_nil flash[:error]
    end
  end
  
  test "everyone should get index" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      get :index
      assert_response :success
      assert_not_nil assigns(:users)
    end
  end
  
  test "everyone should get sorted index" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      get :index, :c => 'login', :d => 'ASC'
      assert_response :success
      assert_not_nil assigns(:users)
    end
  end
  
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
  
  test "anonymous should create user" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      assert_difference('User.count') do
        post :create, :user => { 
          :login => 'temp', 
          :email => 'temp@temp.com', 
          :first_name => 'Temp', 
          :last_name => 'User', 
          :password => 'password', 
          :password_confirmation => 'password',
          :time_zone => Setting.default_time_zone
        }
      end
  
      assert_redirected_to user_path(assigns(:user))
      assert_not_nil flash[:notice]
    end
  end
  
  test "anonymous should not create invalid user" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      assert_no_difference('User.count') do
        post :create, :user => { }
      end
  
      assert_response :success
    end
  end
  
  test "logged in should not create user" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      UserSession.create(users(:admin))
      assert_no_difference('User.count') do
        post :create, :user => { 
          :login => 'temp', 
          :email => 'temp@temp.com', 
          :first_name => 'Temp', 
          :last_name => 'User', 
          :password => 'password', 
          :password_confirmation => 'password',
          :time_zone => Setting.default_time_zone
        }
      end
  
      assert_redirected_to root_path
      assert_not_nil flash[:error]
    end
  end
  
  test "everyone should show user" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      get :show, :id => users(:admin).to_param
      assert_response :success
    end
  end
  
  test "anonymous should not get edit" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      get :edit, :id => users(:admin).to_param
      assert_redirected_to new_user_session_path
    end
  end
  
  test "logged in should get edit" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      UserSession.create(users(:admin))
      get :edit, :id => users(:admin).to_param
      assert_response :success
    end
  end

  test "anonymous should not update user" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      put :update, :id => users(:regular).to_param, :user => { :first_name => "Steven" }
      assert_redirected_to new_user_session_path
      assert_not_nil flash[:error]
    end
  end
  
  test "logged in should update user" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      UserSession.create(users(:regular))
      put :update, :id => users(:regular).to_param, :user => { :first_name => "Steven" }
      assert_redirected_to user_path(assigns(:user))
      assert_not_nil flash[:notice]
    end
  end
  
  test "logged in should not update invalid user" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      UserSession.create(users(:regular))
      put :update, :id => users(:regular).to_param, :user => { :first_name => '' }
      assert_response :success
    end
  end

  test "anonymous should not destroy user" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      assert_no_difference('User.count') do
        delete :destroy, :id => users(:regular).to_param
      end
  
      assert_redirected_to new_user_session_path
      assert_not_nil flash[:error]
    end
  end
  
  test "logged in should destroy user" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      UserSession.create(users(:regular))
      assert_difference('User.count', -1) do
        delete :destroy, :id => users(:regular).to_param
      end
  
      assert_redirected_to root_path
      assert_not_nil flash[:notice]
    end
  end
  
  test "anonymous should not unavatar" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      put :unavatar, :id => users(:regular).to_param
      assert_redirected_to new_user_session_path
      assert_not_nil flash[:error]
    end
  end
  
  test "logged in should unavatar" do
    if ((Setting.maintenance == false) and (Setting.signup == true))
      UserSession.create(users(:regular))
      put :unavatar, :id => users(:regular).to_param
      assert_redirected_to edit_user_path(assigns(:user))
      assert_not_nil flash[:notice]
    end
  end
  
end
