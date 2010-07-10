class CreateSmsNotifies < ActiveRecord::Migration
  def self.up
    create_table :sms_notifies do |t|
      t.string :name
      t.string :mobile_no
      t.timestamps
    end
  end

  def self.down
    drop_table :sms_notifies
  end
end
