class ActivationsController < ApplicationController
  before_filter :require_no_user
  skip_after_filter :store_location
  
  # GET /activate/:activation_code
  def create
    @user = User.find_using_perishable_token(params[:activation_code], 1.week)

    if @user && @user.activate!
      flash[:notice] = t(:account_activated)
      UserSession.create(@user, true)
      @user.deliver_welcome!
    else
      flash[:error] = t(:account_not_activated)
    end
    redirect_back_or_default(root_path)
  end

end