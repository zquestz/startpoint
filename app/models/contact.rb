class Contact < ActiveRecord::Base
  default_scope :order => 'contacts.email ASC'
  
  # Make sure emails are unique and included
  validates_uniqueness_of :email
  validates_format_of :email, :with => Authlogic::Regex.email
  
  # Hook for full name
  def full_name
    "#{first_name} #{last_name}".strip
  end
  
  # Slug the url.
  def to_param
    "#{id}-#{email.parameterize}"
  end
  
  # For pagination system
  def self.per_page
    20
  end
  
end
