class Page < ActiveRecord::Base
  default_scope :order => 'pages.name ASC'
  
  # Scope for protected pages.
  named_scope :protected, :conditions => ['protected = ?', true]
  
  # Stores images
  has_many :page_images
  has_many :images, :through => :page_images
  
  # Stores pdfs
  has_many :page_pdfs
  has_many :pdfs, :through => :page_pdfs
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  # Slug the url.
  def to_param
    "#{id}-#{name.parameterize}"
  end
  
  # For pagination system
  def self.per_page
    20
  end
  
  private
  
  def validate
    if (self.new_record? == false) && self.name_changed?
      errors.add('name', t(:page_name_change_error))
    end
  end
  
end
