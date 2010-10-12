class CreatePageImages < ActiveRecord::Migration
  def self.up
    create_table :page_images do |t|
      t.integer :image_id
      t.integer :page_id

      t.timestamps
    end
    add_index :page_images, [:image_id, :page_id]
  end

  def self.down
    drop_table :page_images
  end
end
