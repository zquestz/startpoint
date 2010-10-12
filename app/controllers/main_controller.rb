class MainController < ApplicationController
  skip_before_filter :check_maintenance, :only => [:maintenance]

  # GET /
  def index
    @page = display_page('Homepage')
    
    respond_to do |format|
      format.html
      format.mobile
    end
  end
  
  # GET /maintenance
  def maintenance
    respond_to do |format|
      format.html
      format.mobile
    end
  end

end
