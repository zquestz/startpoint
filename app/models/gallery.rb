class Gallery < ActiveRecord::Base
  default_scope :order => 'galleries.title ASC'
  
  # Stores images
  has_and_belongs_to_many :images
  
  # Just to track the creator.
  belongs_to :user
  
  # Add in gallery tagging.
  acts_as_taggable_on :tags
  
  # Scope for public galleries.
  named_scope :public, :conditions => ['public = ?', true]
  
  # Protect user_id from mass assignment.
  attr_protected :user_id
  
  validates_presence_of :title, :user
  validates_uniqueness_of :title
  
  # Slug the url.
  def to_param
    "#{id}-#{title.parameterize}"
  end
  
  # For pagination system
  def self.per_page
    20
  end
  
end
