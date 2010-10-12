require 'test_helper'

class Admin::ImagesControllerTest < ActionController::TestCase
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
      get :show, :id => images(:one).to_param
      assert_response :success
    end    
  end
  
  test "admin should get show with preview" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      get :show, :id => images(:one).to_param, :preview => 'edit'
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
      get :edit, :id => images(:one).to_param
      assert_response :success
    end    
  end
  
  test "admin should get edit batches" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      get :edit_batches, :ids => [images(:one).id, images(:two).id]
      assert_response :success
    end    
  end
  
  test "admin should create image" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      assert_difference('Image.count') do
        post :create, :image => { :file => File.new("public/images/seeds/admin.png") }
      end
  
      assert_redirected_to admin_image_path(assigns(:image))
      assert_not_nil flash[:notice]
      
      # Delete paperclip attachment
      Image.find_by_name('admin').destroy
    end
  end
  
  test "admin should not create invalid image" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      assert_no_difference('Image.count') do
        post :create, :image => { }
      end
  
      assert_response :success
    end
  end
  
  test "admin should update image" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      put :update, :id => images(:one).to_param, :image => { :name => "New Title", :page_ids => [1] }
  
      assert_redirected_to admin_image_path(assigns(:image))
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should batch update images" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      put :update_batches, :ids => [images(:one).id, images(:two).id], :image => { 
        :name_1 => "New Name",
        :description_1 => "New Description",
        :tag_list_1 => "tag, tag2",
        :name_2 => "Another New Name",
        :description_2 => "Another New Description",
        :tag_list_2 => "tag, tag2"
      }
  
      assert_redirected_to admin_images_path()
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should delete image" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      delete :destroy, :id => images(:two)
      
      assert_redirected_to admin_images_path
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should not delete image associated to a page" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      pages(:homepage).images << images(:two)
      delete :destroy, :id => images(:two)
      
      assert_redirected_to admin_images_path
      assert_not_nil flash[:error]
    end
  end
  
  test "admin should batch delete images" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      images(:one).pages.clear
      images(:two).pages.clear
      delete :destroy_batches, :ids => [images(:one), images(:two)]
      
      assert_redirected_to admin_images_path
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should not batch delete images associated to a page" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      pages(:homepage).images << images(:two)
      delete :destroy_batches, :ids => [images(:one), images(:two)]
      
      assert_redirected_to admin_images_path
      assert_not_nil flash[:error]
    end
  end
end
