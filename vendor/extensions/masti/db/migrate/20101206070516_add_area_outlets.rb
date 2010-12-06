class AddAreaOutlets < ActiveRecord::Migration
  def self.up
    add_column :outlets,:area,:string
  end

  def self.down
  end
end