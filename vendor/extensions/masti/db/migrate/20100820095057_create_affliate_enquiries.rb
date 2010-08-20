class CreateAffliateEnquiries < ActiveRecord::Migration
  def self.up
    create_table :affliate_enquiries do |t|
      t.string :site_name
      t.string :site_url
      t.string :name
      t.string :email
      t.string :phone_no
      t.string :comments
      t.timestamps
    end
  end

  def self.down
    drop_table :affliate_enquiries
  end
end
