class Admin::PagesController < ApplicationController
  before_filter :require_user
  before_filter :is_admin
  skip_after_filter :store_location, :except => [:index, :show]
  layout 'admin'
  
  uses_tiny_mce :only => [:new, :edit, :create, :update]

  # GET /admin/pages
  # GET /admin/pages.xml  
  def index
    @pages = Page.paginate(
      :select => 'id, name, protected', 
      :page => params[:page], 
      :order => sort_calc('name', {:table => 'pages'})
    )

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  # GET /admin/pages/1
  # GET /admin/pages/1.xml
  def show
    @page = Page.find(params[:id], :include => :images)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /admin/pages/new
  # GET /admin/pages/new.xml
  def new
    @page = Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /admin/pages/1/edit
  def edit
    @page = Page.find(params[:id])
  end

  # POST /admin/pages
  # POST /admin/pages.xml
  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        flash[:notice] = t(:page_created)
        format.html { redirect_back_or_default(admin_page_path(@page)) }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/pages/1
  # PUT /admin/pages/1.xml
  def update
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = t(:page_updated)
        format.html { redirect_back_or_default(admin_page_path(@page)) }
        format.xml  { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/pages/1
  # DELETE /admin/pages/1.xml
  def destroy
    @page = Page.find(params[:id])
    if @page.protected
      flash[:error] = t(:page_protected)
    else
     @page.destroy 
     flash[:notice] = t(:page_deleted)
    end

    respond_to do |format|
      format.html { redirect_back_or_default(admin_pages_url) }
      format.xml  { head :ok }
    end
  end

end
