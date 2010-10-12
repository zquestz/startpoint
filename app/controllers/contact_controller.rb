class ContactController < ApplicationController
  before_filter :check_contact_enabled
  before_filter :setup_contact_page
  
  # GET /contact
  def index
    respond_to do |format|
      format.html
    end
  end

  # POST /contact
  def create
    @contact = params['contact']
    respond_to do |format|
      if validate_contact_fields
        Notifier.send_later :deliver_contact_email, @contact
        flash[:notice] = t(:contact_success)
        format.html { redirect_back_or_default(contact_path) }
      else
        flash.now[:error] = t(:contact_failed)
        format.html { render :action => 'index' }
      end
    end    
  end
  
  private
  
  # Make sure they fill in all fields and provide a usable email address.
  def validate_contact_fields
    (@contact[:email] =~ Authlogic::Regex.email && @contact[:name] != '' && @contact[:message] != '')
  end
  
  # Common page object and meta data for the contact page.
  def setup_contact_page
    @page = display_page('Contact')
  end

end
