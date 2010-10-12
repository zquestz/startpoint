require 'test_helper'

class GalleryTest < ActiveSupport::TestCase
  setup :activate_authlogic

  test "should validate uniqueness of title" do
    gallery = Gallery.create(:title => 'Value')
    gallery.user = users(:admin)
    assert gallery.save
    gallery2 = Gallery.create(:title => 'Value')
    gallery.user = users(:admin)
    assert !gallery2.save
  end
  
  test "should not save without a title" do
    UserSession.create(users(:admin))
    gallery = Gallery.create()
    assert !gallery.save
  end
  
  test "should not save without logged in user" do
    gallery = Gallery.create(:title => 'Not Logged In')
    assert !gallery.save
  end
  
  test "should not save with user_id and title" do
    gallery = Gallery.create(:title => 'Not Logged In', :user_id => users(:admin).to_param)
    assert !gallery.save
  end

end
