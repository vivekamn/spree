class AddCityId < ActiveRecord::Migration
  def self.up
    add_column :products,:city_id,:integer
    add_column :orders,:city_id,:integer
    add_column :deal_histories,:city_id,:integer
  end

  def self.down
    remove_column :products,:city_id
    remove_column :orders,:city_id
    remove_column :deal_histories,:city_id
  end
end