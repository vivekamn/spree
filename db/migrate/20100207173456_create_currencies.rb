class CreateCurrencies < ActiveRecord::Migration
  def self.up
    create_table :currencies do |t|
      t.string :name
      t.string :code
      t.decimal :rate, :precision => 10, :scale => 2, :default => 0.0
      t.boolean :default, :default => false
      t.boolean :enabled, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :currencies
  end
end
