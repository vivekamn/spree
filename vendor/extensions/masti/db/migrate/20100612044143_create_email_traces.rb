class CreateEmailTraces < ActiveRecord::Migration
  def self.up
    create_table :email_traces do |t|
      t.string :email
      t.integer :product_id
      t.timestamps
    end
  end

  def self.down
    drop_table :email_traces
  end
end
