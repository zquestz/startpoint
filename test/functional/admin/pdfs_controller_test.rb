require 'test_helper'

class Admin::PdfsControllerTest < ActionController::TestCase
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
      get :show, :id => pdfs(:one).to_param
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
      get :edit, :id => pdfs(:one).to_param
      assert_response :success
    end    
  end
  
  test "admin should get edit batches" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      get :edit_batches, :ids => [pdfs(:one).id, pdfs(:two).id]
      assert_response :success
    end    
  end
  
  test "admin should create pdf" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      assert_difference('Pdf.count') do
        post :create, :pdf => { :file => File.new("public/images/seeds/sample3.pdf") }
      end
  
      assert_redirected_to admin_pdf_path(assigns(:pdf))
      assert_not_nil flash[:notice]
      
      # Delete paperclip attachment
      Pdf.find_by_name('sample').destroy
    end
  end
  
  test "admin should not create invalid pdf" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      assert_no_difference('Pdf.count') do
        post :create, :pdf => { }
      end
  
      assert_response :success
    end
  end
  
  test "admin should update pdf" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      put :update, :id => pdfs(:one).to_param, :pdf => { :name => "New Title", :page_ids => [1] }
  
      assert_redirected_to admin_pdf_path(assigns(:pdf))
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should batch update pdfs" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      put :update_batches, :ids => [pdfs(:one).id, pdfs(:two).id], :pdf => { 
        :name_1 => "New Name",
        :description_1 => "New Description",
        :tag_list_1 => "tag, tag2",
        :name_2 => "Another New Name",
        :description_2 => "Another New Description",
        :tag_list_2 => "tag, tag2"
      }
  
      assert_redirected_to admin_pdfs_path()
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should delete pdf" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      delete :destroy, :id => pdfs(:two)
      
      assert_redirected_to admin_pdfs_path
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should not delete pdf associated to a page" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      pages(:homepage).pdfs << pdfs(:two)
      delete :destroy, :id => pdfs(:two)
      
      assert_redirected_to admin_pdfs_path
      assert_not_nil flash[:error]
    end
  end
  
  test "admin should batch delete pdfs" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      pdfs(:one).pages.clear
      pdfs(:two).pages.clear
      delete :destroy_batches, :ids => [pdfs(:one), pdfs(:two)]
      
      assert_redirected_to admin_pdfs_path
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should not batch delete pdfs associated to a page" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      pages(:homepage).pdfs << pdfs(:two)
      delete :destroy_batches, :ids => [pdfs(:one), pdfs(:two)]
      
      assert_redirected_to admin_pdfs_path
      assert_not_nil flash[:error]
    end
  end
end
