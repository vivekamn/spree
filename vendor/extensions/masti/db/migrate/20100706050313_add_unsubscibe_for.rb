class AddUnsubscibeFor < ActiveRecord::Migration
  def self.up
    add_column :users,:unusbcribed,:boolean,:default=>false
    add_column :deals_notifications,:unusbcribed,:boolean,:default=>false
  end

  def self.down
    remove_column :users,:unusbcribed
    remove_column :deals_notifications,:unusbcribed
  end
end