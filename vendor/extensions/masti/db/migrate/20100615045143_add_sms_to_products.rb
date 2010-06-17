class AddSmsToProducts < ActiveRecord::Migration
  def self.up
    change_column :products, :deal_info, :text
    add_column :products, :gift_sms ,:string
    add_column :products, :sms_notification,:string
  end

  def self.down
  end
end