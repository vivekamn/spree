class AddSampleDealHistory < ActiveRecord::Migration
  def self.up
    add_column :deal_histories,:is_sample,:boolean,:default =>false 
  end

  def self.down
    remove_column :deal_histories,:is_sample
  end
end