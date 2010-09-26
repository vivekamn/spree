class AddSessionKeyToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :session_key, :string
  end

  def self.down
    remove_column :users, :session_key
  end
end