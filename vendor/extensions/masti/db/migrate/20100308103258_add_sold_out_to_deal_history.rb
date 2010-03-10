class AddSoldOutToDealHistory < ActiveRecord::Migration
  def self.up
    add_column :deal_histories, :sold_out, :boolean, :default=>false
  end

  def self.down
    remove_column :deal_histories, :sold_out
  end
end
