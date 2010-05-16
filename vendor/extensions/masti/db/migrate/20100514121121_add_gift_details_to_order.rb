class AddGiftDetailsToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :gift, :boolean
    add_column :orders, :giftee_name, :string
    add_column :orders, :giftee_email, :string
    add_column :orders, :giftee_phone_no, :string
  end

  def self.down
    remove_column :orders, :gift
    remove_column :orders, :giftee_name
    remove_column :orders, :giftee_email
    remove_column :orders, :giftee_phone_no
  end
end
