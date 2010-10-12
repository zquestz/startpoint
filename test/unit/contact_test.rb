require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  setup :activate_authlogic

  test "should validate uniqueness of email" do
    contact = Contact.create(:email => 'yum@yummy.com')
    assert contact.save
    contact2 = Contact.create(:email => 'yum@yummy.com')
    assert !contact2.save
  end
  
  test "should not save without a email" do
    UserSession.create(users(:admin))
    contact = Contact.create()
    assert !contact.save
  end
  
  test "should not save with an invalid email" do
    UserSession.create(users(:admin))
    contact = Contact.create(:email => 'blam@com')
    assert !contact.save
  end
  
  test "should save without logged in user" do
    contact = Contact.create(:email => 'valid@valid.com')
    assert contact.save
  end
end
