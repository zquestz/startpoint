require 'test_helper'

class PageTest < ActiveSupport::TestCase

  test "should fail to save when the name changes" do
    page = Page.create(:name => 'Killer')
    assert page.save
    page.name = 'New'
    assert !page.save
  end

  test "should validate uniqueness of name" do
    page = Page.create(:name => 'Value')
    assert page.save
    page2 = Page.create(:name => 'Value')
    assert !page2.save
  end
  
  test "should not save without a name" do
    page = Page.create()
    assert !page.save
  end

end
