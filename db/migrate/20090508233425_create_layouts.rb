class CreateLayouts < ActiveRecord::Migration
  def self.up
    create_table :layouts do |t|
      t.string :name
      t.string :location
      t.string :screenshot_file_name
      t.string :screenshot_content_type
      t.integer :screenshot_file_size
      
    end
    
    create_table :layouts_taxons do |t|
      t.references :taxon
      t.references :layout
    end
  end

  def self.down
    drop_table :layouts
    drop_table :layouts_taxons
  end
end
