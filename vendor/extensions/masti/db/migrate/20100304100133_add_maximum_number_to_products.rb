class AddMaximumNumberToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :maximum_number, :integer
  end

  def self.down
    remove_column :products, :maximum_number
  end
end
