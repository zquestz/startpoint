class Admin::PdfsController < ApplicationController
  before_filter :require_user
  before_filter :is_admin
  skip_after_filter :store_location, :except => [:index, :show]
  layout 'admin'
  
  # GET /admin/pdfs
  # GET /admin/pdfs.xml
  def index
    @pdfs = Pdf.paginate(
      :select => 'id, user_id, name, file_file_name',
      :include => [:user, :pages],
      :page => params[:page], 
      :order => sort_calc('name', {:table => 'pdfs'})
    )

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.xml  { render :xml => @pdfs }
    end
  end

  # GET /admin/pdfs/1
  # GET /admin/pdfs/1.xml
  def show
    @pdf = Pdf.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pdf }
    end
  end

  # GET /admin/pdfs/new
  # GET /admin/pdfs/new.xml
  def new
    @pdf = Pdf.new

    respond_to do |format|
      format.html # new.html.erb
      format.js
      format.xml  { render :xml => @pdf }
    end
  end

  # GET /admin/pdfs/1/edit
  def edit
    @pdf = Pdf.find(params[:id])
  end
  
  # GET /admin/pdfs/:ids/edit
  def edit_batches
    @pdfs = Pdf.find(params[:ids])
  end

  # POST /admin/pdfs
  # POST /admin/pdfs.xml
  def create
    # For uploadify
    if params['Filedata']
      @pdf = Pdf.new(:uploadify_file => params['Filedata'])
      @pdf.user = current_user
      respond_to do |format|
        if @pdf.save
          flash[:success]  = t(:pdf_created)
          flash[:pdf_id] = @pdf.id
          format.html { render :text => flash.to_json, :status => 200 }
        else
          flash[:error] = t(:pdf_create_error)
          format.html { render :text => flash[:error], :status => 500 }
        end
      end
    else
      @pdf = Pdf.new(params[:pdf])
      @pdf.user = current_user
      respond_to do |format|
        if @pdf.save
          flash[:notice] = t(:pdf_created)
          format.html { redirect_back_or_default(admin_pdf_path(@pdf)) }
          format.xml  { render :xml => @pdf, :status => :created, :location => @pdf }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @pdf.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /admin/pdfs/1
  # PUT /admin/pdfs/1.xml
  def update
    @pdf = Pdf.find(params[:id], :include => :pages)

    respond_to do |format|
      params[:pdf][:page_ids] ||= []
      # Get associated page names for cache expiration
      associated_page_names = @pdf.pages.map {|p| p.name unless params[:pdf][:page_ids].include?(p.id)}
      if @pdf.update_attributes(params[:pdf])
        # Expire page caches now that pdfs are updated.
        for page_name in associated_page_names
          expire_page_cache(page_name)
        end
        flash[:notice] = t(:pdf_updated)
        format.html { redirect_back_or_default(admin_pdf_path(@pdf)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pdf.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /admin/pdfs/:ids
  def update_batches
    @pdfs = Pdf.find(params[:ids], :include => :pages)
    associated_page_names = []
    @pdfs.each do |pdf|
      # page_ids can't be nil or it breaks association cache logic
      params[:pdf]["page_ids_#{pdf.id}"] ||= []
      # Get associated page names for cache expiration
      associated_page_names += pdf.pages.map {|p| p.name unless params[:pdf]["page_ids_#{pdf.id}"].include?(p.id)}
      pdf.page_ids = params[:pdf]["page_ids_#{pdf.id}"]
      pdf.name = params[:pdf]["name_#{pdf.id}"]
      pdf.description = params[:pdf]["description_#{pdf.id}"]
      pdf.tag_list = params[:pdf]["tag_list_#{pdf.id}"]
    end
    respond_to do |format|
      if @pdfs.map(&:save)
        # Expire page caches now that pdfs are updated.
        for page_name in associated_page_names.uniq
          expire_page_cache(page_name)
        end
        flash[:notice] = t(:pdfs_updated)
        format.html { redirect_back_or_default(admin_pdfs_path) }
      else
        format.html { render :action => "edit_batches" }
      end
    end
  end

  # DELETE /admin/pdfs/1
  # DELETE /admin/pdfs/1.xml
  def destroy
    @pdf = Pdf.find(params[:id])
    if @pdf.destroy
      flash[:notice] = t(:pdf_deleted)
    else
      flash[:error] = t(:pdf_not_deleted)
    end

    respond_to do |format|
      format.html { redirect_back_or_default(admin_pdfs_path) }
      format.xml  { head :ok }
    end
  end
  
  # DELETE /admin/pdfs/:ids
  def destroy_batches
    @pdfs = Pdf.destroy(params[:ids])
    if @pdfs.include?(false)
      flash[:error] = t(:pdfs_not_deleted)
    else
      flash[:notice] = t(:pdfs_deleted)
    end

    respond_to do |format|
      format.html { redirect_back_or_default(admin_pdfs_url) }
      format.xml  { head :ok }
    end
  end
  
end
