require 'test_helper'

class ExtendRubyClassesTest < ActiveSupport::TestCase

  test "except should work" do
    assert({:val => 1, :another => 2}.except(:val) == {:another => 2})
  end

  test "with should work" do
    assert({:val => 1, :another => 2}.with(:val => 5) == {:val => 5, :another => 2})
  end
  
  test "only should work" do
    assert({:val => 1, :another => 2}.only(:val) == {:val => 1})
  end
  
  test "recurvsive merge should work" do
    assert({:val => {:first => 1, :second => 2}}.recursive_merge({:val => {:first => 2, :third => 3}}) == {:val => {:first => 2, :second => 2, :third => 3}})
  end

end