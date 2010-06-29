class AddReffreal < ActiveRecord::Migration
  def self.up
    add_column :users,:refered_by,:string
  end

  def self.down
    remove_column :users,:refered_by
  end
end