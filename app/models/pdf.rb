class Pdf < ActiveRecord::Base
  default_scope :order => 'pdfs.name ASC'
  
  # Accessor for batch methods
  attr_accessor :pdf_ids
  
  # Page support
  has_many :page_pdfs
  has_many :pages, :through => :page_pdfs
  
  # Just to track the creator.
  belongs_to :user
  
  # Make sure deleted pdfs aren't associated to any pages.
  # This needs to be up here before any paperclip associations or we see 
  # the paperclip pdf get deleted even if the model shouldn't be deleted.
  before_destroy :check_pages

  # Add in pdf tagging.  
  acts_as_taggable_on :tags
  
  # Protect user_id from mass assignment.
  attr_protected :user_id
  
  has_attached_file :file, 
  :url => '/system/:class/:attachment/:id/:style/:filename', 
  :default_url => '/paperclip/:class/:attachment/:style/missing.png'

  validates_attachment_presence :file
  validates_attachment_content_type :file, :content_type => ['application/pdf', 'application/x-pdf']
  validates_attachment_size :file, :less_than => 20.megabytes, :message =>"must be under 20 megabytes."  
  
  # Make sure the pdf is unique.
  validates_uniqueness_of :md5
  
  # Setup some extra fields about the pdf.
  before_validation :prep_pdf
    
  # For uploadify support
  def uploadify_file=(file_data)
    file_data.content_type = MIME::Types.type_for(file_data.original_filename).to_s
    self.file = file_data
  end
  
  # Valid file extensions
  def extensions
    ext = ["pdf"]
    return ext.uniq
  end
  
  # Slug the url.
  def to_param
    "#{id}-#{name.parameterize}"
  end

  # For pagination system
  def self.per_page
    20
  end
  
  private
  
  # Cleanup pdfs before deletion
  def check_pages
    if pages.length > 0
      return false
    end
    return true
  end
  
  # Scrub ugly chars, create a nice default name for the pdf, and set height/width
  def prep_pdf
    # Make sure we actually have a good paperclip file object before we prep.
    if file && file.original_filename
      self.name = self.file.original_filename.sub(/#{Regexp.escape(File.extname(file.original_filename))}$/, '').gsub(/[^a-zA-Z0-9-]/, ' ').squeeze(" ") if self.name.blank?
      if self.description.blank?
        self.description = ""
      end
      if self.file.queued_for_write[:original].present?
        current_file = self.file.queued_for_write[:original].path
        self.md5 = Digest::MD5.hexdigest(File.read(current_file))
      end
    end
  end
end