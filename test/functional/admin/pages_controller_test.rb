require 'test_helper'

class Admin::PagesControllerTest < ActionController::TestCase
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
      get :show, :id => pages(:homepage).to_param
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
      get :edit, :id => pages(:homepage).to_param
      assert_response :success
    end    
  end
  
  test "admin should create page" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      assert_difference('Page.count') do
        post :create, :page => { :name => 'Test' }
      end
  
      assert_redirected_to admin_page_path(assigns(:page))
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should not create invalid page" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      assert_no_difference('Page.count') do
        post :create, :page => { }
      end
  
      assert_response :success
    end
  end
  
  test "admin should update page" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      put :update, :id => pages(:homepage).to_param, :page => { :heading => "New Heading" }
  
      assert_redirected_to admin_page_path(assigns(:page))
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should not update invalid page" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      put :update, :id => pages(:homepage).to_param, :page => { :name => 'Change Name' }
  
      assert_response :success
    end
  end
  
  test "admin should delete page" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      delete :destroy, :id => pages(:unprotected)
      
      assert_redirected_to admin_pages_path
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin shouldn't delete protected page" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      delete :destroy, :id => pages(:homepage)
      
      assert_redirected_to admin_pages_path
      assert_not_nil flash[:error]
    end
  end
end
