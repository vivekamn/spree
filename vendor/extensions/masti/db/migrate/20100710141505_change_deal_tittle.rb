class ChangeDealTittle < ActiveRecord::Migration
  def self.up
    change_column :products,:name,:string,:limit =>512  
  end

  def self.down
    change_column :products,:name,:string
  end
end