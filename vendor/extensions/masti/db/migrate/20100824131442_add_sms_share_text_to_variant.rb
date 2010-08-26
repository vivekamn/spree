class AddSmsShareTextToVariant < ActiveRecord::Migration
  def self.up
    add_column :variants,:sms_share_text,:string
  end

  def self.down
    remove_column :variants,:sms_share_text
  end
end