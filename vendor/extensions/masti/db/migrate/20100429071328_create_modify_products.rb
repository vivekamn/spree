class CreateModifyProducts < ActiveRecord::Migration
  def self.up    
    change_column :products, :currently_bought_count, :integer, :default => 0, :null => false
  end

  def self.down
   
  end
end
