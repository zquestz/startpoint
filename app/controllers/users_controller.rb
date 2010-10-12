class UsersController < ApplicationController
  before_filter :check_signup_allowed
  before_filter :require_user, :only => [:edit, :update, :destroy, :unavatar]
  before_filter :require_no_user, :only => [:new, :create]
  
  skip_after_filter :store_location, :except => [:index, :show]
  
  # GET /users
  # GET /users.xml
  def index
    if (params[:d] || params[:c])
      @users = User.active.paginate(:select => 'id, login, avatar_file_name', :page => params[:page], :order => sort_calc('created_at', {:rev => true, :table => 'users'}))
    else
      if Rails.configuration.cache_classes == true
        @users = Rails.cache.fetch(['accounts_index', params[:page] || 1].join('-')) do
          User.active.paginate(:select => 'id, login, avatar_file_name, created_at, active', :page => params[:page], :order => sort_calc('created_at', {:rev => true, :table => 'users'}))
        end
      else
        @users = User.active.paginate(:select => 'id, login, avatar_file_name, created_at, active', :page => params[:page], :order => sort_calc('created_at', {:rev => true, :table => 'users'}))
      end
    end
    
    setup_meta_data
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    if Rails.configuration.cache_classes == true
      @user = Rails.cache.fetch(['accounts_show', strip_slug(params[:id])].join('-')) do
        User.find(params[:id])
      end
    else
      @user = User.find(params[:id])
    end
    
    setup_meta_data

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(current_user)
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    
    # Automatically activate the user
    @user.activate if Setting.email_activation == false

    respond_to do |format|
      # Save without session management because the automatic managment is delayed.
      # Therefore we handle it ourselves.
      if verify_recaptcha(:model => @user, :message => t(:recaptcha_invalid)) && @user.save_without_session_maintenance
        if Setting.email_activation == true
          flash[:notice] = t(:account_activation)
          @user.deliver_activation_instructions!
        else
          flash[:notice] = t(:account_created)
          UserSession.create(@user, true)
        end
        format.html { redirect_back_or_default(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(current_user)

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = t(:account_updated)
        format.html { redirect_back_or_default(user_path(@user)) }
        format.xml  { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET /users/unavatar/1
  def unavatar
    user = User.find(current_user)
    user.avatar = nil
    if user.save
      flash[:notice] = t(:avatar_removed)
    else
      flash[:error] = t(:avatar_not_removed)
    end
    respond_to do |format|
      format.html { redirect_back_or_default(edit_user_path(user))}
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(current_user)
    @user.destroy
    current_user_session.destroy

    respond_to do |format|
      flash[:notice] = t(:account_deleted)
      format.html { redirect_back_or_default(root_path) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  # Setup meta data
  def setup_meta_data
    case self.action_name
      when 'show' then
        @page_title = I18n.translate(:user_show_page_title, :app_name => Setting.app_name, :user => @user.login)
        @page_description =  I18n.translate(:user_show_page_description, :app_name => Setting.app_name, :user => @user.login)
        @page_keywords = I18n.translate(:user_show_page_keywords, :app_name => Setting.app_name, :user => @user.login)
      when 'index' then
        @page_title = I18n.translate(:user_index_page_title, :app_name => Setting.app_name)        
        @page_description = I18n.translate(:user_index_page_description, :app_name => Setting.app_name)
        @page_keywords = I18n.translate(:user_index_page_keywords, :app_name => Setting.app_name)
    end
  end

end
