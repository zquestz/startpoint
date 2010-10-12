class Admin::ContactsController < ApplicationController
  before_filter :require_user
  before_filter :is_admin
  skip_after_filter :store_location, :except => [:index, :show]
  layout 'admin'
  
  # GET /admin/contacts
  # GET /admin/contacts.xml
  def index
    @contacts = Contact.paginate(
      :select => 'id, email, created_at',
      :page => params[:page], 
      :order => sort_calc('email', {:table => 'contacts'})
    )

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.xml  { render :xml => @contacts }
    end
  end

  # GET /admin/contacts/1
  # GET /admin/contacts/1.xml
  def show
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /admin/contacts/new
  # GET /admin/contacts/new.xml
  def new
    @contact = Contact.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /admin/contacts/1/edit
  def edit
    @contact = Contact.find(params[:id])
  end
  
  # POST /admin/contacts
  # POST /admin/contacts.xml
  def create
    @contact = Contact.new(params[:contact])
    respond_to do |format|
      if @contact.save
        flash[:notice] = t(:contact_created)
        format.html { redirect_back_or_default(admin_contact_path(@contact)) }
        format.xml  { render :xml => @contact, :status => :created, :location => @contact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET /admin/contacts/export
  def export
    send_data(
      Contact.export, 
      :filename => "contacts-#{Time.now.strftime('%d-%m-%Y-%H-%M')}.csv", 
      :type => 'text/csv', 
      :disposition => 'attachment'
    )
  end

  # PUT /admin/contacts/1
  # PUT /admin/contacts/1.xml
  def update
    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        flash[:notice] = t(:contact_updated)
        format.html { redirect_back_or_default(admin_contact_path(@contact)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /admin/contacts/1
  # DELETE /admin/contacts/1.xml
  def destroy
    @contact = Contact.find(params[:id])
    if @contact.destroy
      flash[:notice] = t(:contact_deleted)
    else
      flash[:error] = t(:contact_not_deleted)
    end

    respond_to do |format|
      format.html { redirect_back_or_default(admin_contacts_path) }
      format.xml  { head :ok }
    end
  end
  
  # DELETE /admin/contacts/:ids
  def destroy_batches
    @contacts = Contact.destroy(params[:ids])
    if @contacts.include?(false)
      flash[:error] = t(:contacts_not_deleted)
    else
      flash[:notice] = t(:contacts_deleted)
    end

    respond_to do |format|
      format.html { redirect_back_or_default(admin_contacts_url) }
      format.xml  { head :ok }
    end
  end
  
end
