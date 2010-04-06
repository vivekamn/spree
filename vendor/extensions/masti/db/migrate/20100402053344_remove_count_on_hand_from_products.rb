class RemoveCountOnHandFromProducts < ActiveRecord::Migration
  def self.up
    remove_column :products, :count_on_hand
  end

  def self.down
  end
end