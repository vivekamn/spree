class Change < ActiveRecord::Migration
  def self.up
    change_column :enquiries, :phone_no, :string 
  end

  def self.down
    change_column :enquiries, :phone_no,:integer
  end
end