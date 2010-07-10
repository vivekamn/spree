class AddSideDealDealHistory < ActiveRecord::Migration
  def self.up
    add_column :deal_histories,:is_side_deal,:boolean,:default => false 
  end

  def self.down
    remove_column :deal_histories,:is_side_deal
  end
end