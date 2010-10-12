class AdminController < ApplicationController
  before_filter :require_user
  before_filter :is_admin
  layout 'admin'
  
  # Main admin page
  # GET /admin
  def index
    @page = display_page('Admin')
    
    respond_to do |format|
      format.html
    end
  end
  
end