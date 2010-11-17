class AddUnlimitedFalgProducts < ActiveRecord::Migration
  def self.up
    add_column :products,:show_master_price,:boolean,:default=>true
  end

  def self.down
    remove_column :products,:show_master_price
  end
end