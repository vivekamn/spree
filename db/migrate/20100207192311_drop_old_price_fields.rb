class DropOldPriceFields < ActiveRecord::Migration
  def self.up
    remove_column :variants, :price
  end

  def self.down
    add_column :products, :price, :decimal,      :precision => 8, :scale => 2, :null => false
  end
end
