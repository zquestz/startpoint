require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  
  test "helper display_website" do
    website = 'http://google.com'
    output = display_website(website)
    assert_match %r{href}, output
    assert_match %r{#{website}}, output
  end
  
  test "helper display_email" do
    email = 'someone@someone.com'
    output = display_email(email)
    assert_match %r{mailto}, output
    assert_match %r{#{email}}, output
  end
  
  test "should have functional select_tag" do
    output = select_tag('name', options_for_select(['Option']))
    assert_match %r{option}, output
  end
  
  test "should have include_blank in select_tag" do
    output = select_tag('name', options_for_select(['Option']), :include_blank => true)
    assert_match %r{<option value="">}, output
  end
  
  test "should have prompt in select_tag" do
    output = select_tag('name', options_for_select(['Option']), :prompt => 'Select An Item')
    assert_match %r{<option value="">Select An Item}, output
  end
  
end
