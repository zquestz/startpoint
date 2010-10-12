require 'test_helper'

class ContactControllerTest < ActionController::TestCase
  setup :activate_authlogic  
  
  # Make sure pages don't load when contact is turned off.
  test "contact page disabled" do
    if ((Setting.maintenance == false) and (Setting.contact == false))
      get :index
      assert_redirected_to root_path
      assert_not_nil flash[:error]
    end
  end
  
  test "everyone should get index" do
    if ((Setting.maintenance == false) and (Setting.contact == true))
      get :index
      assert_response :success
      assert_not_nil assigns(:page)
    end
  end
  
  test "everyone should submit contact message" do
    if ((Setting.maintenance == false) and (Setting.contact == true))
      post :create, :contact => { 
        :type => "General Message", 
        :name => 'Test User', 
        :email => 'temp@temp.com', 
        :message => "Test message."
      }

      assert_redirected_to contact_path
      assert_not_nil flash[:notice]
    end
  end
  
  test "everyone should not submit invalid contact message" do
    if ((Setting.maintenance == false) and (Setting.contact == true))
      post :create, :contact => { }
  
      assert_response :success
      assert_not_nil flash[:error]
    end
  end
  
end
