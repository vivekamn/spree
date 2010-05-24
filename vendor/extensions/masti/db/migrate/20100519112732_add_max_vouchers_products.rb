class AddMaxVouchersProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :max_vouchers, :integer
  end

  def self.down
    remove_column :products, :max_vouchers
  end
end