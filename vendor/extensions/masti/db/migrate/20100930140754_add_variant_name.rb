class AddVariantName < ActiveRecord::Migration
  def self.up
    add_column :variants,:c_name,:string
  end

  def self.down
    remove_column :variants,:c_name
  end
end