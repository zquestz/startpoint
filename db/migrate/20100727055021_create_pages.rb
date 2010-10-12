class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :name
      t.string :title
      t.string :heading
      t.text :content
      t.text :meta_description
      t.string :meta_keywords
      t.boolean :protected

      t.timestamps
    end
    add_index :pages, :name
  end

  def self.down
    drop_table :pages
  end
end
