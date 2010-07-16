class AddSourceNotification < ActiveRecord::Migration
  def self.up
    add_column :deals_notifications, :source ,:string
  end

  def self.down
    remove_column :deals_notifications, :source
  end
end