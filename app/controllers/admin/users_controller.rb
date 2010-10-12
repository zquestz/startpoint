class Admin::UsersController < ApplicationController
  before_filter :require_user
  before_filter :is_admin
  skip_after_filter :store_location, :except => [:index, :show]
  layout 'admin'
  
  # GET /admin/users
  # GET /admin/users.xml
  def index
    @users = User.paginate(
      :select => 'id, login, first_name, last_name, email, is_admin, avatar_file_name, active', 
      :page => params[:page], 
      :order => sort_calc('login', {:table => 'users'})
    )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /admin/users/1
  # GET /admin/users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /admin/users/new
  # GET /admin/users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /admin/users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /admin/users
  # POST /admin/users.xml
  def create
    @user = User.new(params[:user])
    
    # Always activate users created in the admin.
    @user.activate

    respond_to do |format|
      if @user.save_without_session_maintenance
        flash[:notice] = t(:user_created)
        format.html { redirect_back_or_default(admin_user_path(@user)) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/users/1
  # PUT /admin/users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = t(:user_updated)
        format.html { redirect_back_or_default(admin_user_path(@user)) }
        format.xml  { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /admin/users/create_admin/1
  def create_admin
    @user = User.find(params[:id])
    if @user.is_admin
      flash[:notice] = t(:user_already_promoted)
    else
      @user.upgrade_to_admin!
      flash[:notice] = t(:user_promoted)
    end
    respond_to do |format|
      format.html { redirect_back_or_default(admin_users_url) }
    end
  end
  
  # PUT /admin/users/demote_admin/1
  def demote_admin
    @user = User.find(params[:id])
    if @user.is_admin
      @user.demote_admin!
      if @user.is_admin
        flash[:error] = t(:user_not_demoted)
      else
        flash[:notice] = t(:user_demoted)
      end
    else
      flash[:notice] = t(:user_already_demoted)
    end
    respond_to do |format|
      format.html { redirect_back_or_default(admin_users_url) }
    end
  end

  # PUT /admin/users/unavatar/1
  def unavatar
    user = User.find(params[:id])
    user.avatar = nil
    if user.save 
      flash[:notice] = t(:avatar_removed)
    else
      flash[:error] = t(:avatar_not_removed)
    end
    respond_to do |format|
      format.html { redirect_back_or_default(edit_admin_user_path(user))}
    end
  end
  
  # PUT /admin/uesrs/activate/1
  def activate
    @user = User.find(params[:id])
    if @user.active?
      flash[:notice] = t(:user_already_activated)
    else
      flash[:notice] = t(:user_activated)
      @user.activate!
    end
    respond_to do |format|
      format.html { redirect_back_or_default(admin_users_path)}
    end
  end

  # DELETE /admin/users/1
  # DELETE /admin/users/1.xml
  def destroy
    @user = User.find(params[:id])
    if @user.is_admin
      flash[:error] = t(:user_not_deleted)
    else
     @user.destroy 
     flash[:notice] = t(:user_deleted)
    end

    respond_to do |format|
      format.html { redirect_back_or_default(admin_users_url) }
      format.xml  { head :ok }
    end
  end
  
end