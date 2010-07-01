class AddPhoneVerifyToUser < ActiveRecord::Migration
  def self.up
    add_column :users,:mobile_verify,:boolean,:default=>false
    add_column :users,:invited_count,:integer,:default=>0
  end

  def self.down
    remove_column :users,:mobile_verify
    remove_column :users,:invited_count
  end
end