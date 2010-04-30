class VoucherTextProduct < ActiveRecord::Migration
  def self.up
     add_column :products, :deal_info, :string
     add_column :products, :voucher_text, :string
     
  end

  def self.down
    remove_column :products, :deal_info
     remove_column :products, :voucher_text
  end
end