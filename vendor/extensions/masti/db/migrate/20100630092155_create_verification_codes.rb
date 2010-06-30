class CreateVerificationCodes < ActiveRecord::Migration
  def self.up
    create_table :verification_codes do |t|
      t.integer :user_id
      t.string :code
      t.string :verify_type
      t.timestamps
    end
  end

  def self.down
    drop_table :verification_codes
  end
end
