class AddSideDealTitle < ActiveRecord::Migration
  def self.up
    add_column :products, :side_deal_title, :string 
  end

  def self.down
    remove_column :products, :side_deal_title 
  end
end