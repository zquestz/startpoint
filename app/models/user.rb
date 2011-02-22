class User < ActiveRecord::Base
  default_scope :order => 'users.login ASC'
  
  # Only display active users on the front end.
  named_scope :active, :conditions => ['active = ?', true]
  
  has_many :galleries
  
  # Make sure passwords are a bit more secure.
  acts_as_authentic do |config|
    password_length_constraints = config.validates_length_of_password_field_options.reject { |k,v| [:minimum, :maximum].include?(k) }
    config.validates_length_of_password_field_options = password_length_constraints.merge :within => 8..24
  end
  
  # Protect is_admin and active from mass assignment.
  attr_protected :is_admin, :active
  
  has_attached_file :avatar, :styles => { :medium => '300x300>', :thumb => '100x100>', :large_icon => '64x64#', :icon => '32x32#' }, :url => '/system/:class/:attachment/:id/:style/:filename', :default_url => '/paperclip/:class/:attachment/:style/missing.png'
  
  validates_presence_of :first_name, :last_name, :time_zone
  
  # Validate attachement if it is present.
  validates_attachment_content_type :avatar, :content_type => ['image/pjpeg','image/jpeg','image/png','image/gif']
  validates_attachment_size :avatar, :less_than => 1.megabyte, :message => t(:user_avatar_size_error)
  
  # Slug the url.
  def to_param
    "#{id}-#{login.parameterize}"
  end
  
  # Promote to admin
  def upgrade_to_admin
    unless self.is_admin
      self.is_admin = true
    end
  end
  
  # Promote to admin and save
  def upgrade_to_admin!
    unless self.is_admin
      self.is_admin = true
      self.save
    end
  end

  # Demote admin
  def demote_admin
    if self.is_admin && (User.admin_users_count > 1)
      self.is_admin = false
    end
  end
  
  # Demote admin and save
  def demote_admin!
    if self.is_admin && (User.admin_users_count > 1)
      self.is_admin = false
      self.save
    end
  end
  
  # Activate user
  def activate
    unless self.active?
      self.active = true
    else
      true
    end
  end
  
  # Activate user and save
  def activate!
    unless self.active?
      self.active = true
      self.save
    else
      true
    end
  end
  
  # For pagination system
  def self.per_page
    20
  end
  
  # Count number of regular users
  def self.regular_users_count
    if Rails.configuration.cache_classes == true
      Rails.cache.fetch('regular_user_count') do
        User.count(:conditions => ['is_admin = ?', false])
      end
    else
      User.count(:conditions => ['is_admin = ?', false])
    end
  end
  
  # Count number of admin users
  def self.admin_users_count
    if Rails.configuration.cache_classes == true
      Rails.cache.fetch('admin_user_count') do
        User.count(:conditions => ['is_admin = ?', true])
      end
    else
      User.count(:conditions => ['is_admin = ?', true])
    end
  end
  
  # Count number of total users
  # This reads from cached data and is quite quick.
  def self.total_users_count
    self.regular_users_count + self.admin_users_count
  end
  
  # Send password reset instructions
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.delay.deliver_password_reset_instructions(self)
  end

  # Send activation instructions
  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.delay.deliver_activation_instructions(self)
  end
  
  # Send welcome message
  def deliver_welcome!
    reset_perishable_token!
    Notifier.delay.deliver_welcome(self)
  end
  
  # Allow logins via email or login
  def self.find_by_login_or_email(login)
    User.find_by_login(login) || User.find_by_email(login)
  end

end
