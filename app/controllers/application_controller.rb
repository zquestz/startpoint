class ApplicationController < ActionController::Base
  # Enable mobile support
  has_mobile_fu
  
  helper_method :current_user_session, :current_user, :is_admin, :safe_location
  
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  before_filter :check_maintenance, :set_time_zone
  after_filter :store_location, :if => Proc.new {|c| c.request.format.html?}

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  
  # Run cache sweeper
  cache_sweeper :master_sweeper
  
  private
  
  # Set time zone for app based on user setting
  def set_time_zone
    Time.zone = current_user.time_zone if @current_user
  end
  
  # Provides caching, images, meta tags for pages.
  def display_page(page_name)
    if Rails.configuration.cache_classes == true
      page = Rails.cache.fetch(['show_page', page_name].join('-')) do
        Page.find(:first, :conditions => ['name = ?', page_name], :include => [:images, :pdfs]) || Page.create!(:name => page_name, :protected => true)
      end
    else
      page = Page.find(:first, :conditions => ['name = ?', page_name], :include => [:images, :pdfs]) || Page.create!(:name => page_name, :protected => true)
    end
    setup_meta_data(page)
    return page
  end
  
  # Expire page cache
  def expire_page_cache(page_name)
    if Rails.configuration.cache_classes == true
      Rails.cache.delete("show_page-#{page_name}")
    end
  end
  
  # Default way to setup meta data for Page objects.
  def setup_meta_data(page)
    @page_title = page.title if page.title.present?
    @page_description = page.meta_description if page.meta_description.present?
    @page_keywords = page.meta_keywords if page.meta_keywords.present?
  end
  
  # Setup order clause for Model.find
  # Can be passed either a single col/direction
  # Or you can send it arrays. 
  def sort_calc(cols, options = {})
    rev = options[:rev] || []
    cols = Array(cols) if cols.class != Array
    rev = Array(rev) if rev.class != Array
    order_info = []
    cols.each_with_index do |col, index|
      if rev[index] == true
        dir = (params[:d] == 'ASC') ? 'ASC' : 'DESC'
      else
        dir = (params[:d] == 'DESC' ? 'DESC' : 'ASC')
      end
      if options[:table]
        order_info.push "#{options[:table] + '.' + (params[:c] || col.to_s).gsub(/[\s;'\"]/,'')} #{dir}"
      else
        order_info.push "#{(params[:c] || col.to_s).gsub(/[\s;'\"]/,'')} #{dir}"
      end
    end
    return order_info.join(', ')
  end
  
  # Check to see if we should go into maintenance mode.
  def check_maintenance
    if Setting.maintenance == true
      redirect_to maintenance_path
    end
  end
  
  # Check whether we allow user signup.
  def check_signup_allowed
    if Setting.signup == false
      flash[:error] = t(:signup_disabled)
      redirect_back_or_default(root_path)
    end
  end
  
  # Check if blog features are enabled
  def check_blog_enabled
    if Setting.blog == false
      flash[:error] = t(:blog_disabled)
      redirect_back_or_default(root_path)
    end
  end
  
  # Check if contact page is enabled
  def check_contact_enabled
    if Setting.contact == false
      flash[:error] = t(:contact_disabled)
      redirect_back_or_default(root_path)
    end
  end
  
  # Get plain id value from slugged attribute
  def strip_slug(param)
    param.split('-')[0]
  end
  
  # Get current user session
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  # Get current user
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
  
  # Check if a user is an admin
  def is_admin
    unless @current_user.is_admin
      flash[:error] = t(:must_be_admin)
      redirect_to root_path
      return false
    end
  end

  # Require user to be logged in
  def require_user
    unless current_user
      store_location
      flash[:error] = t(:must_be_logged_in)
      redirect_to new_user_session_url
      return false
    end
  end

  # Require the user not be logged in
  def require_no_user
    if current_user
      store_location
      flash[:error] = t(:must_be_logged_out)
      redirect_to root_path
      return false
    end
  end

  # Store a url in the session that is safe to go back to (non-volatile)
  def store_location
    session[:return_to] = request.request_uri
  end
  
  # Get safe redirect location or set default
  def safe_location(default)
    session[:return_to] || default
  end

  # Redirect back to last good page, or the page you pass it if it doesn't know where to go.
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
end