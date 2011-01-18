class AddNewCities < ActiveRecord::Migration
  def self.up
    city_arr =['Delhi / NCR','Kolkotta','Pune','Chandigarh']
    state_abbr = ['DEL','WB','MAH','HIM']
    city_arr.each_with_index do |city_name,i|
      state = State.find(:first,:conditions=>['abbr = ?',state_abbr[i]],:order=>"id desc")
      city = City.new(:name=>city_name,:state_id=>state.id,:is_active=>true)
      city.save
    end
    city = City.find_by_name('Mumbai')
    city.is_active=true
    city.save
  end

  def self.down
    
  end
end