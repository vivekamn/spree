class ModifyPaymentAndTransaction < ActiveRecord::Migration
  def self.up
    add_column :payments, :status, :string, :null=>true
    add_column :transactions, :date_created, :datetime, :null=>true
    
  end

  def self.down
    remove_column :payments, :status
    remove_column :transactions, :date_created    
  end
end