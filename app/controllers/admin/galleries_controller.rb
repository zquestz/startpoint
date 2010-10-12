class Admin::GalleriesController < ApplicationController
  before_filter :require_user
  before_filter :is_admin
  skip_after_filter :store_location, :except => [:index, :show]
  layout 'admin'
  
  uses_tiny_mce :only => [:new, :edit, :create, :update]

  # GET /admin/galleries
  # GET /admin/galleries.xml  
  def index
    @galleries = Gallery.paginate(
      :select => 'id, user_id, title, public', 
      :include => :user,
      :page => params[:page], 
      :order => sort_calc('title', {:table => 'galleries'})
    )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @galleries }
    end
  end

  # GET /admin/galleries/1
  # GET /admin/galleries/1.xml
  def show
    @gallery = Gallery.find(params[:id], :include => [:user, :images])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gallery }
    end
  end

  # GET /admin/galleries/new
  # GET /admin/galleries/new.xml
  def new
    @gallery = Gallery.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gallery }
    end
  end

  # GET /admin/galleries/1/edit
  def edit
    @gallery = Gallery.find(params[:id])
  end

  # POST /admin/galleries
  # POST /admin/galleries.xml
  def create
    @gallery = Gallery.new(params[:gallery])
    @gallery.user = current_user

    respond_to do |format|
      if @gallery.save
        flash[:notice] = t(:gallery_created)
        format.html { redirect_back_or_default(admin_gallery_path(@gallery)) }
        format.xml  { render :xml => @gallery, :status => :created, :location => @gallery }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @gallery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/galleries/1
  # PUT /admin/galleries/1.xml
  def update
    @gallery = Gallery.find(params[:id])

    respond_to do |format|
      if @gallery.update_attributes(params[:gallery])
        flash[:notice] = t(:gallery_updated)
        format.html { redirect_back_or_default(admin_gallery_path(@gallery)) }
        format.xml  { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @gallery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/galleries/1
  # DELETE /admin/galleries/1.xml
  def destroy
    @gallery = Gallery.find(params[:id])
    @gallery.destroy 
    flash[:notice] = t(:gallery_deleted)

    respond_to do |format|
      format.html { redirect_back_or_default(admin_galleries_url) }
      format.xml  { head :ok }
    end
  end

end