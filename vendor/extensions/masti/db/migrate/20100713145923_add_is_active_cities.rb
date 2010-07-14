class AddIsActiveCities < ActiveRecord::Migration
  def self.up
    add_column :cities, :is_active, :boolean, :default => 0
  end

  def self.down
    remove_column :cities, :is_active
  end
end