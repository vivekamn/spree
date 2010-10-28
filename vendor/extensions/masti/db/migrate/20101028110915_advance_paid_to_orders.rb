class AdvancePaidToOrders < ActiveRecord::Migration
  def self.up
   add_column :orders,:advance_paid,:boolean,:default=>true
  end

  def self.down
    remove_column :orders,:advance_paid
  end
end