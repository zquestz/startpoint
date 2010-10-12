class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.integer :user_id
      t.string :name
      t.text :description
      t.string :md5
      t.string :file_file_name
      t.string :file_content_type
      t.integer :file_file_size
      t.datetime :file_updated_at
      t.integer :width
      t.integer :height

      t.timestamps
    end
    
    create_table(:galleries_images, :id => false) do |t|
      t.references :image
      t.references :gallery
      
      t.timestamps
    end
    
    add_index :images, :user_id
    add_index :images, :name
    add_index :images, :md5
    add_index :images, [:width, :height]
    
    add_index :galleries_images, [:gallery_id, :image_id]
  end

  def self.down
    drop_table :images
    drop_table :galleries_images
  end
end
