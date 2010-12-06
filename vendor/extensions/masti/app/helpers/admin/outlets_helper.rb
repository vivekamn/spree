module Admin::OutletsHelper
   def get_city_names
    cities=[]
    city=City.find(:all, :conditions => ['is_active = ? ',  true])
    city.each do |cty|
      cities<<[cty.name, cty.id]
    end
     cities 
  end
end
