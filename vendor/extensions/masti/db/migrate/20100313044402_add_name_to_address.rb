class AddNameToAddress < ActiveRecord::Migration
  def self.up
    add_column :addresses, :name, :string
  end

  def self.down
    remove_column :address, :name
  end
end
