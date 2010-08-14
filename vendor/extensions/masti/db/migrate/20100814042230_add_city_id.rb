class AddCityId < ActiveRecord::Migration
  def self.up
    add_column :users, :city_id, :integer, :default => 1
    add_column :products, :city_id, :integer, :default => 1
    add_column :orders,:city_id,:integer, :default => 1
    add_column :deal_histories,:city_id,:integer, :default => 1
  end

  def self.down
    remove_column :users, :city_id
    remove_column :products, :city_id
    remove_column :orders, :city_id
    remove_column :deal_histories, :city_id
  end
end