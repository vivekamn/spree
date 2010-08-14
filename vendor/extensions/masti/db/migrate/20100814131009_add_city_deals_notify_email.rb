class AddCityDealsNotifyEmail < ActiveRecord::Migration
  def self.up
    add_column :deals_notifications, :city_id, :integer, :default => 1
  end

  def self.down
    remove_column :deals_notifications, :city_id
  end
end