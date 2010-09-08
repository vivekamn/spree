class AddFlagMdMoney < ActiveRecord::Migration
  def self.up
    add_column :products,:use_md_money,:boolean,:default=>true
  end

  def self.down
    remove_column :products,:use_md_money
  end
end