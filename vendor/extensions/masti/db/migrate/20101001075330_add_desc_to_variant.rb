class AddDescToVariant < ActiveRecord::Migration
  def self.up
    add_column :variants,:c_description,:text
    add_column :variants, :category, :string
    add_column :variants, :unit, :string
    add_column :variants, :image_url, :string
  end

  def self.down
    remove_column :variants,:c_description
    remove_column :variants, :category
    remove_column :variants, :unit
    remove_column :variants, :image_url
  end
end