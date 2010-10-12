class CreatePdfs < ActiveRecord::Migration
  def self.up
    create_table :pdfs do |t|
      t.integer :user_id
      t.string :name
      t.text :description
      t.string :md5
      t.string :file_file_name
      t.string :file_content_type
      t.integer :file_file_size
      t.datetime :file_updated_at

      t.timestamps
    end
    
    add_index :pdfs, :user_id
    add_index :pdfs, :name
    add_index :pdfs, :md5
  end

  def self.down
    drop_table :pdfs
  end
end
