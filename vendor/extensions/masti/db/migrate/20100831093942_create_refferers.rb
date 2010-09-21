class CreateRefferers < ActiveRecord::Migration
  def self.up
    create_table :refferers do |t|
      t.string  :email
      t.string  :code
      t.integer  :user_id
      t.column  :invite_count,:integer,:default=>0
      t.column  :voucher_sent,:integer,:default=>0
      t.timestamps
    end
  end

  def self.down
    drop_table :refferers
  end
end
