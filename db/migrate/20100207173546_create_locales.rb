class CreateLocales < ActiveRecord::Migration
  def self.up
    create_table :locales do |t|
      t.string :name
      t.string :code
      t.boolean :enabled, :default => true
      t.boolean :default, :default => false
      t.integer :position
      t.timestamps
    end
  end

  def self.down
    drop_table :locales
  end
end
