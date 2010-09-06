class ChangeBagaluru < ActiveRecord::Migration
  def self.up
    city =  City.find_by_name('Bangalore')
    city.name = "Bengaluru"
    city.save
  end

  def self.down
  end
end