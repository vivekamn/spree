class DiscountChange < ActiveRecord::Migration
  def self.up
     change_column :products, :discount, :decimal,:precision => 8, :scale => 2, :default => 0.0
  end

  def self.down
  end
end