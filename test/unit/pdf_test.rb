require 'test_helper'

class PdfTest < ActiveSupport::TestCase
  test "should not create empty pdf" do
    pdf = Pdf.new
    assert !pdf.save
  end
end
