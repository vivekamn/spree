class CreateOutlets < ActiveRecord::Migration
  def self.up
    create_table :outlets do |t|
      t.string :address1
      t.string :address2
      t.integer :city_id
      t.integer :product_id
      t.string :pincode
      t.string :contact_person
      t.string :contact_no
      
      t.timestamps
    end
  end

  def self.down
    drop_table :outlets
  end
end
