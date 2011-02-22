require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  setup :activate_authlogic

  # Make sure anonymous users can't get to this controller
  test "anonymous should not get index" do
    if Setting.maintenance == false
      get :index
      assert_redirected_to new_user_session_path
      assert_not_nil flash[:error]
    end
  end
  
  # Make sure non-admin's can't get to this controller
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
    end
  end
  
  test "admin should get show" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      get :show, :id => users(:admin).to_param
      assert_response :success
    end    
  end
  
  test "admin should get new" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      get :new
      assert_response :success
    end    
  end
  
  test "admin should get edit" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      get :edit, :id => users(:admin).to_param
      assert_response :success
    end    
  end
  
  test "admin should create user" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
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
  
      assert_redirected_to admin_user_path(assigns(:user))
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should not create invalid user" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      assert_no_difference('User.count') do
        post :create, :user => { }
      end
  
      assert_response :success
    end
  end
  
  test "admin should update user" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      put :update, :id => users(:regular).to_param, :user => { :first_name => "Steve" }
  
      assert_redirected_to admin_user_path(assigns(:user))
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should not update invalid user" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      put :update, :id => users(:regular).to_param, :user => { :first_name => '' }
  
      assert_response :success
    end
  end
  
  test "admin should create_admin (new)" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      put :create_admin, :id => users(:regular).to_param
  
      assert_redirected_to admin_users_path
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should create_admin (existing)" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      put :create_admin, :id => users(:admin).to_param
  
      assert_redirected_to admin_users_path
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should demote_admin" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      put :demote_admin, :id => users(:admin2).to_param
      
      assert_redirected_to admin_users_path
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should not demote_admin on regular user" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      put :demote_admin, :id => users(:regular).to_param
      
      assert_redirected_to admin_users_path
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should unavatar" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      put :unavatar, :id => users(:admin).to_param
  
      assert_redirected_to edit_admin_user_path(assigns(:user))
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should activate (already activated)" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      put :activate, :id => users(:admin).to_param
      
      assert_redirected_to admin_users_path
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should activate (not activated)" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      put :activate, :id => users(:inactive).to_param
      
      assert_redirected_to admin_users_path
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should delete user" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      delete :destroy, :id => users(:regular)
      
      assert_redirected_to admin_users_path
      assert_not_nil flash[:notice]
    end
  end

end
