class AddCityIdUser < ActiveRecord::Migration
  def self.up
    add_column :users, :city_id, :integer, :default => 1
  end

  def self.down
    remove_column :users, :city_id
  end
end