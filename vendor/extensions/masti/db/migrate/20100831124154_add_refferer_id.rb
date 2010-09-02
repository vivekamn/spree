class AddReffererId < ActiveRecord::Migration
  def self.up
    add_column :users,:refferer_id,:integer
  end

  def self.down
    remove_column :users,:refferer_id
  end
end