class CreateDealsNotifications < ActiveRecord::Migration
   def self.up
    create_table :deals_notifications do |t|
      t.string :email, :null => false,:unique => true
      t.boolean :is_send_email, :default => 0
      t.timestamps
    end
    add_index "deals_notifications", ["email"], :name => "email_1uq", :unique => true    
  end

  def self.down
    drop_table :deals_notifications
  end
end
