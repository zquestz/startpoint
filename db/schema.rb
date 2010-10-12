# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101012035126) do

  create_table "contacts", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["email"], :name => "index_contacts_on_email"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "galleries", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.boolean  "public"
    t.text     "meta_description"
    t.string   "meta_keywords"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "galleries", ["title"], :name => "index_galleries_on_title"

  create_table "galleries_images", :id => false, :force => true do |t|
    t.integer  "image_id"
    t.integer  "gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "galleries_images", ["gallery_id", "image_id"], :name => "index_galleries_images_on_gallery_id_and_image_id"

  create_table "images", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.string   "md5"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "images", ["md5"], :name => "index_images_on_md5"
  add_index "images", ["name"], :name => "index_images_on_name"
  add_index "images", ["user_id"], :name => "index_images_on_user_id"
  add_index "images", ["width", "height"], :name => "index_images_on_width_and_height"

  create_table "page_images", :force => true do |t|
    t.integer  "image_id"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_images", ["image_id", "page_id"], :name => "index_page_images_on_image_id_and_page_id"

  create_table "page_pdfs", :force => true do |t|
    t.integer  "pdf_id"
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_pdfs", ["pdf_id", "page_id"], :name => "index_page_pdfs_on_pdf_id_and_page_id"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "heading"
    t.text     "content"
    t.text     "meta_description"
    t.string   "meta_keywords"
    t.boolean  "protected"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["name"], :name => "index_pages_on_name"

  create_table "pdfs", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.text     "description"
    t.string   "md5"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pdfs", ["md5"], :name => "index_pdfs_on_md5"
  add_index "pdfs", ["name"], :name => "index_pdfs_on_name"
  add_index "pdfs", ["user_id"], :name => "index_pdfs_on_user_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "is_admin",            :default => false
    t.boolean  "active",              :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["active"], :name => "index_users_on_active"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

end
