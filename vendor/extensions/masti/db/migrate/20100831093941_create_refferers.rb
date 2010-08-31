class CreateRefferers < ActiveRecord::Migration
  def self.up
    create_table :refferers do |t|
      t.string  :email
      t.string  :code
      t.integer  :user_id
      t.integer  :invite_count
      t.integer  :voucher_sent
      t.timestamps
    end
  end

  def self.down
    drop_table :refferers
  end
end
