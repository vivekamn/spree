class CreateVendors < ActiveRecord::Migration
  def self.up
    create_table :vendors do |t|
      t.string :name, :null => false
      t.string :address
      t.string :permalink
      t.string :contact_person_name, :null => false
      t.integer :state_id
      t.string :city            
      t.string :zip
      t.string :phone_no, :null => false
      t.string :email, :null => false
      t.datetime :deleted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :vendors
  end
end
