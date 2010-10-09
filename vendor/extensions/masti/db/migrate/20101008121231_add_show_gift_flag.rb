class AddShowGiftFlag < ActiveRecord::Migration
  def self.up
    add_column :products,:show_gift,:boolean,:default=>true
  end

  def self.down
    remove_column :products,:show_gift
  end
end