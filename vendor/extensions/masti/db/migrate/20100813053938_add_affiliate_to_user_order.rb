class AddAffiliateToUserOrder < ActiveRecord::Migration
  def self.up
    add_column :users, :affiliate_id, :string
    add_column :users, :paid_affiliate, :boolean, :default => false
    add_column :orders, :affiliate_id, :string
    add_column :orders, :paid_affiliate, :boolean, :default => false
  end

  def self.down
    remove_column :users, :affiliate_id
    remove_column :users, :paid_affiliate
    remove_column :orders, :affiliate_id
    remove_column :orders, :paid_affiliate
  end
end