class AddSourceTracking < ActiveRecord::Migration
  def self.up
    add_column :users,:source,:string
    add_column :orders,:source,:string
  end

  def self.down
    remove_column :users,:source
    remove_column :orders,:source
  end
end