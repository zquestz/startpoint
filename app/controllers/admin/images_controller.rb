class Admin::ImagesController < ApplicationController
  before_filter :require_user
  before_filter :is_admin
  skip_after_filter :store_location, :except => [:index, :show]
  layout 'admin'
  
  # GET /admin/images
  # GET /admin/images.xml
  def index
    @images = Image.paginate(
      :select => 'id, user_id, name, file_file_name',
      :include => [:user, :galleries, :pages],
      :page => params[:page], 
      :order => sort_calc('name', {:table => 'images'})
    )

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.xml  { render :xml => @images }
    end
  end

  # GET /admin/images/1
  # GET /admin/images/1.xml
  def show
    @image = Image.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @image }
    end
  end

  # GET /admin/images/new
  # GET /admin/images/new.xml
  def new
    @image = Image.new

    respond_to do |format|
      format.html # new.html.erb
      format.js
      format.xml  { render :xml => @image }
    end
  end

  # GET /admin/images/1/edit
  def edit
    @image = Image.find(params[:id])
  end
  
  # GET /admin/images/:ids/edit
  def edit_batches
    @images = Image.find(params[:ids])
  end

  # POST /admin/images
  # POST /admin/images.xml
  def create
    # For uploadify
    if params['Filedata']
      @image = Image.new(:uploadify_file => params['Filedata'])
      @image.user = current_user
      respond_to do |format|
        if @image.save
          flash[:success]  = t(:image_created)
          flash[:image_id] = @image.id
          format.html { render :text => flash.to_json, :status => 200 }
        else
          flash[:error] = t(:image_create_error)
          format.html { render :text => flash[:error], :status => 500 }
        end
      end
    else
      @image = Image.new(params[:image])
      @image.user = current_user
      respond_to do |format|
        if @image.save
          flash[:notice] = t(:image_created)
          format.html { redirect_back_or_default(admin_image_path(@image)) }
          format.xml  { render :xml => @image, :status => :created, :location => @image }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @image.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /admin/images/1
  # PUT /admin/images/1.xml
  def update
    @image = Image.find(params[:id], :include => :pages)

    respond_to do |format|
      params[:image][:gallery_ids] ||= []
      params[:image][:page_ids] ||= []
      # Get associated page names for cache expiration
      associated_page_names = @image.pages.map {|p| p.name unless params[:image][:page_ids].include?(p.id)}
      if @image.update_attributes(params[:image])
        # Expire page caches now that images are updated.
        for page_name in associated_page_names
          expire_page_cache(page_name)
        end
        flash[:notice] = t(:image_updated)
        format.html { redirect_back_or_default(admin_image_path(@image)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @image.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /admin/images/:ids
  def update_batches
    @images = Image.find(params[:ids], :include => :pages)
    associated_page_names = []
    @images.each do |image|
      # page_ids can't be nil or it breaks association cache logic
      params[:image]["page_ids_#{image.id}"] ||= []
      # Get associated page names for cache expiration
      associated_page_names += image.pages.map {|p| p.name unless params[:image]["page_ids_#{image.id}"].include?(p.id)}
      image.gallery_ids = params[:image]["gallery_ids_#{image.id}"]
      image.page_ids = params[:image]["page_ids_#{image.id}"]
      image.name = params[:image]["name_#{image.id}"]
      image.description = params[:image]["description_#{image.id}"]
      image.tag_list = params[:image]["tag_list_#{image.id}"]
    end
    respond_to do |format|
      if @images.map(&:save)
        # Expire page caches now that images are updated.
        for page_name in associated_page_names.uniq
          expire_page_cache(page_name)
        end
        flash[:notice] = t(:images_updated)
        format.html { redirect_back_or_default(admin_images_path) }
      else
        format.html { render :action => "edit_batches" }
      end
    end
  end

  # DELETE /admin/images/1
  # DELETE /admin/images/1.xml
  def destroy
    @image = Image.find(params[:id])
    if @image.destroy
      flash[:notice] = t(:image_deleted)
    else
      flash[:error] = t(:image_not_deleted)
    end

    respond_to do |format|
      format.html { redirect_back_or_default(admin_images_path) }
      format.xml  { head :ok }
    end
  end
  
  # DELETE /admin/images/:ids
  def destroy_batches
    @images = Image.destroy(params[:ids])
    if @images.include?(false)
      flash[:error] = t(:images_not_deleted)
    else
      flash[:notice] = t(:images_deleted)
    end

    respond_to do |format|
      format.html { redirect_back_or_default(admin_images_url) }
      format.xml  { head :ok }
    end
  end
  
end
