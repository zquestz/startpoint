class CreateGalleries < ActiveRecord::Migration
  def self.up
    create_table :galleries do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.boolean :public
      t.text :meta_description
      t.string :meta_keywords

      t.timestamps
    end
    add_index :galleries, :title
  end

  def self.down
    drop_table :galleries
  end
end
