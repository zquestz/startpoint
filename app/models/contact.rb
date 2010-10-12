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
  
  # Export as csv
  def self.export
    contacts = find(:all)
    csv_data = FasterCSV.generate do |csv|
      csv << [I18n.t('activerecord.attributes.contact.email'), I18n.t('activerecord.attributes.contact.first_name'), I18n.t('activerecord.attributes.contact.last_name'), I18n.t('activerecord.attributes.contact.phone'), I18n.t('activerecord.attributes.contact.created_at'), I18n.t('activerecord.attributes.contact.updated_at')]
      for contact in contacts
        csv << [contact.email, contact.first_name, contact.last_name, contact.phone, contact.created_at, contact.updated_at]
      end
    end
    return csv_data
  end
  
end