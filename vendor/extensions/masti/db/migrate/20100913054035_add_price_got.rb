class AddPriceGot < ActiveRecord::Migration
  def self.up
    add_column :active_poll_user_answers,:price_no,:integer,:null => true 
  end

  def self.down
    remove_column :active_poll_user_answers,:price_no
  end
end