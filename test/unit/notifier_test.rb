require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  
  test "send password reset instructions" do
    user = users(:admin)
    email = Notifier.deliver_password_reset_instructions(user)
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal [user.email], email.to
    assert_not_nil email.subject
  end
  
  test "send activation instructions" do
    user = users(:admin)
    email = Notifier.deliver_activation_instructions(user)
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal [user.email], email.to
    assert_not_nil email.subject
  end
  
  test "send welcome" do
    user = users(:admin)
    email = Notifier.deliver_welcome(user)
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal [user.email], email.to
    assert_not_nil email.subject
  end
  
  test "send contact email" do
    contact = {
      :type => 'General Message',
      :name => 'Test',
      :email => 'test@test.com',
      :message => 'Test message.'
    }
    email = Notifier.deliver_contact_email(contact)
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal [Setting.support_email], email.to
    assert_not_nil email.subject
  end
end