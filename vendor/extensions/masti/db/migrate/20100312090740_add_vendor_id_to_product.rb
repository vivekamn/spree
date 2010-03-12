class AddVendorIdToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :vendor_id, :integer, :null => false, :default=>0 
  end

  def self.down
    remove_column :products, :vendor_id
  end
end