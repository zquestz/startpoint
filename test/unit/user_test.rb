require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  test "should not create empty user" do
    user = User.new
    assert !user.save
  end
  
  test "should create valid user" do
    user = User.create(
      :login => 'newuser', 
      :email => 'newuser@user.com', 
      :first_name => 'New', 
      :last_name => 'User', 
      :password => 'password', 
      :password_confirmation => 'password'
    )
    assert user.save
  end
  
  test "should ignore is_admin and active attributes on mass assignment" do
    user = User.create(
      :login => 'newuser', 
      :email => 'newuser@user.com',
      :first_name => 'New', 
      :last_name => 'User', 
      :password => 'password', 
      :password_confirmation => 'password', 
      :is_admin => true, 
      :active => true
    )
    assert user.save
    assert !user.is_admin
    assert !user.active?
  end

  test "should upgrade_to_admin!" do
    user = users(:regular)
    user.upgrade_to_admin!
    assert user.is_admin
    assert !user.changed?
  end
  
  test "should upgrade_to_admin" do
    user = users(:regular)
    user.upgrade_to_admin
    assert user.is_admin
    assert user.changed?
  end
  
  test "should demote_admin!" do
    user = users(:admin2)
    user.demote_admin!
    assert !user.is_admin
    assert !user.changed?
  end
  
  test "should demote_admin" do
    user = users(:admin2)
    user.demote_admin
    assert !user.is_admin
    assert user.changed?
  end
  
  test "should demote_admin! for all but last admin" do
    user = users(:admin2)
    user.demote_admin!
    user = users(:admin)
    user.demote_admin!
    assert user.is_admin
    assert !user.changed?
  end
  
  test "should demote_admin for all but last admin" do
    user = users(:admin2)
    user.demote_admin!
    user = users(:admin)
    user.demote_admin
    assert user.is_admin
    assert !user.changed?
  end
  
  test "should activate! inactive user" do
    user = users(:inactive)
    user.activate!
    assert user.active?
    assert !user.changed?
  end
  
  test "should activate inactive user" do
    user = users(:inactive)
    user.activate
    assert user.active?
    assert user.changed?
  end
  
  test "should activate! active user" do
    user = users(:admin)
    user.activate!
    assert user.active?
    assert !user.changed?
  end
  
  test "should activate active user" do
    user = users(:admin)
    user.activate
    assert user.active?
    assert !user.changed?
  end
  
  test "should find user via email" do
    user = User.find_by_login_or_email(users(:admin)[:login])
    assert_not_nil user
  end
  
  test "should find user via login" do
    user = User.find_by_login_or_email(users(:admin)[:email])
    assert_not_nil user
  end
  
end
