class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.string :name, :null=>false
      t.integer :state_id, :null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :cities
  end
end
