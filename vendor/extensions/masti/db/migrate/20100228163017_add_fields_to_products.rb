class AddFieldsToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :discount, :integer, :default => 0, :null => false
    add_column :products, :minimum_number, :integer, :default => 50, :null => false
    add_column :products, :currently_bought_count, :integer, :default => 10, :null => false
    add_column :products, :deal_expiry_date, :datetime, :null => false
    add_column :products, :contact_info, :string
    add_column :products, :validity_from, :datetime
    add_column :products, :validity_to, :datetime
    add_column :products, :catch_message, :text
    add_column :products, :location, :string
  end

  def self.down
    remove_column :products, :discount
    remove_column :products, :minimum_number
    remove_column :products, :currently_bought_count
    remove_column :products, :deal_expiry_date
    remove_column :products, :contact_info
    remove_column :products, :validity_from
    remove_column :products, :validity_to
    remove_column :products, :catch_message
    remove_column :products, :location
  end
end
