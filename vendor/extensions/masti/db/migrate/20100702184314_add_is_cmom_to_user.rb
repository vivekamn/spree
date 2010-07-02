class AddIsCmomToUser < ActiveRecord::Migration
  def self.up
    add_column :users,:is_cmom,:boolean,:default => false 
  end

  def self.down
    remove_column :users,:is_cmom
  end
end