class AddUsersFb < ActiveRecord::Migration
  def self.up
    add_column :users, :fb_user_id, :double
    add_column :users, :email_hash, :string
  end

  def self.down
    remove_column :users, :fb_user_id
    remove_column :users, :email_hash

  end
end
