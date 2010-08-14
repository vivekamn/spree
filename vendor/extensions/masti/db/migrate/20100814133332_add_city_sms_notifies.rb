class AddCitySmsNotifies < ActiveRecord::Migration
  def self.up
    add_column :sms_notifies, :city_id, :integer, :default => 1
  end

  def self.down
    remove_column :sms_notifies, :city_id
  end
end