class AddCityToAdderess < ActiveRecord::Migration
  def self.up
    add_column :enquiries,:city_id,:integer,:default=>1
  end

  def self.down
    remove_column :enquiries,:city_id
  end
end