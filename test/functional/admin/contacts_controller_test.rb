require 'test_helper'

class Admin::ContactsControllerTest < ActionController::TestCase
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
      get :show, :id => contacts(:full).to_param
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
      get :edit, :id => contacts(:full).to_param
      assert_response :success
    end    
  end
  
  test "admin should create contact" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      assert_difference('Contact.count') do
        post :create, :contact => { :email => 'someone@else.com' }
      end
  
      assert_redirected_to admin_contact_path(assigns(:contact))
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should not create invalid contact" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      assert_no_difference('Contact.count') do
        post :create, :contact => { }
      end
  
      assert_response :success
    end
  end
  
  test "admin should not create contact with invalid email" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      assert_no_difference('Contact.count') do
        post :create, :contact => { :email => 'boo' }
      end
  
      assert_response :success
    end
  end
  
  test "admin should update contact" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      put :update, :id => contacts(:full).to_param, :contact => { :first_name => "Steve" }
  
      assert_redirected_to admin_contact_path(assigns(:contact))
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should not update contact with invalid email" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      put :update, :id => contacts(:full).to_param, :contact => { :email => "bad" }
  
      assert_response :success
    end
  end
  
  test "admin should delete contact" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      delete :destroy, :id => contacts(:partial)
      
      assert_redirected_to admin_contacts_path
      assert_not_nil flash[:notice]
    end
  end
  
  test "admin should batch delete contacts" do
    if Setting.maintenance == false
      UserSession.create(users(:admin))
      delete :destroy_batches, :ids => [contacts(:full), contacts(:partial)]
      
      assert_redirected_to admin_contacts_path
      assert_not_nil flash[:notice]
    end
  end
  
end
