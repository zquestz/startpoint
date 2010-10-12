class PagePdf < ActiveRecord::Base
  belongs_to :page
  belongs_to :pdf
end
