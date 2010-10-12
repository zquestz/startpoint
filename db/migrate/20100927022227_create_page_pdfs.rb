class CreatePagePdfs < ActiveRecord::Migration
  def self.up
    create_table :page_pdfs do |t|
      t.integer :pdf_id
      t.integer :page_id

      t.timestamps
    end
    add_index :page_pdfs, [:pdf_id, :page_id]
  end

  def self.down
    drop_table :page_pdfs
  end
end
