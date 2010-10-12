class PasswordResetsController < ApplicationController
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [ :edit, :update ]
  skip_after_filter :store_location
  
  # GET /password_resets
  def new
  end

  # POST /password_resets/email@email.com
  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = t(:email_reset_success)
      redirect_back_or_default(root_path)
    else
      if !(params[:email] =~ Authlogic::Regex.email)
        flash[:error] = t(:email_reset_not_valid)
      else
        flash[:error] = t(:email_reset_not_found)
      end
      render :action => :new
    end
  end

  # GET /password_resets/:id/edit
  # :id will be the perishable_token
  def edit
  end

  # PUT /password_resets/:id
  # :id will be the perishable_token
  def update
    respond_to do |format|
      if params[:user][:password].present? and @user.update_attributes(params[:user])
        flash[:notice] = t(:password_updated)
        format.html { redirect_back_or_default(user_path(@user)) }
        format.xml  { head :ok }
      else
        flash.now[:error] = t(:password_confirm) if params[:user][:password].blank?
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  private

  # Load user using perishable token instead of id
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:error] = t(:account_not_found)
      redirect_back_or_default(root_url)
    end
  end
  
end
