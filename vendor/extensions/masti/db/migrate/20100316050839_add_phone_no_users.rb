class AddPhoneNoUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :phone_no, :string
  end

  def self.down
    remove_column :users, :phone_no
  end
end