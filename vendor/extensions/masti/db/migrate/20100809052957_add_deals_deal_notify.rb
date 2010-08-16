class AddDealsDealNotify < ActiveRecord::Migration
  def self.up
    add_column :deals_notifications,:deals,:string
  end

  def self.down
    remove_column :deals_notifications,:deals
  end
end