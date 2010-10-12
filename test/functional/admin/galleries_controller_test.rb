require 'test_helper'

class Admin::GalleriesControllerTest < ActionController::TestCase
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
  
  test "admin should get show for public" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      get :show, :id => galleries(:public).to_param
      assert_response :success
    end    
  end
  
  test "admin should get show for private" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      get :show, :id => galleries(:private).to_param
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
      get :edit, :id => galleries(:public).to_param
      assert_response :success
    end    
  end
  
  test "admin should create gallery" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      assert_difference('Gallery.count') do
        post :create, :gallery => { :title => 'Test' }
      end
  
      assert_redirected_to admin_gallery_path(assigns(:gallery))
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should not create invalid gallery" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      assert_no_difference('Gallery.count') do
        post :create, :gallery => { }
      end
  
      assert_response :success
    end
  end
  
  test "admin should update gallery" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      put :update, :id => galleries(:private).to_param, :gallery => { :title => "New Title" }
  
      assert_redirected_to admin_gallery_path(assigns(:gallery))
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should not update invalid gallery" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      put :update, :id => galleries(:public).to_param, :gallery => { :title => '' }
  
      assert_response :success
    end
  end
  
  test "admin should delete page" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      delete :destroy, :id => galleries(:private)
      
      assert_redirected_to admin_galleries_path
      assert_not_nil flash[:notice]
    end
  end

end
