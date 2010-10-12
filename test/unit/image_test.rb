require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  test "should not create empty image" do
    image = Image.new
    assert !image.save
  end
end
