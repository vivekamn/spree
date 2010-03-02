class CreateEnquiries < ActiveRecord::Migration
  def self.up
    create_table :enquiries do |t|
      t.string  :first_name, :null => false
      t.string  :last_name, :null => false
      t.string  :company, :null => false
      t.integer :phone_no, :null => false
      t.string  :city, :null => false
      t.text    :query, :null => false
      t.string  :email, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :enquiries
  end
end
