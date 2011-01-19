module HomeHelper
  
  def call_category_for_xml(category)
    category_arr = {}
    category_arr['Health, Beauty & Spa']=1
    category_arr['Food & Dining']=2
    category_arr['Entertainment']=3
    category_arr['Electronics']=4
    category_arr['Computers']=5
    category_arr['Mobile']=6
    category_arr['Gifts & Toys']=7
    category_arr['Furniture & Furnishing']=8
    category_arr['Books & Stationery']=9
    category_arr['Automobiles']=10
    category_arr['Travel & Holiday']=11
    category_arr['Fashion & Accessories']=13
    category_arr['Art & Hobby']=14
    return category_arr[category].nil? ? "3" : category_arr[category]
  end
  
  
  def call_city_for_xml(city_id)
    city_array = ['0','5','3','1','2','7']
    return city_array[city_id]
  end
  
  def web_browser
      ua = request.env["HTTP_USER_AGENT"]
      return "Firefox3" if ua[/Firefox\/3/]=="Firefox/3"
      return "Firefox2" if ua[/Firefox\/2/]=="Firefox/2"
      return "MSIE6" if ua[/MSIE 6/]=="MSIE 6"
      return "MSIE7" if ua[/MSIE 7/]=="MSIE 7"
      return "MSIE8" if ua[/MSIE 8/]=="MSIE 8"
      return "Opera" if ua[/Opera/]=="Opera"
    end
      
    def ie_check
       ua = web_browser()
      if ua == "MSIE6" or ua == "MSIE7"
        return true
      else
        return false
      end
    end

  def progress_bar current_deal
      if current_deal.currently_bought_count>=current_deal.minimum_number
        bought_percent = 300
      else
          bought_percent = (current_deal.currently_bought_count*300)/current_deal.minimum_number
      end
  end
  
   def page_title
     if @featured_product
       if session[:city_id].to_s == '1'
          "Daily Deals in Chennai | Cheap Deals Discount | Great Discount Coupons | Best Deals Website - Masthideals.com" 
       elsif session[:city_id].to_s == '2'
          "Bengaluru Restaurant Deals | Good Spa Reviews | Online Shopping Discount | Movie Tickets Coupon - Masthideals.com"
       elsif session[:city_id].to_s == '3'
          "Best Deals on Restaurants, Saloons, Gyms, Entertainment in Mumbai, India - Masthideals.com"   
       elsif session[:city_id].to_s == '5'
          "Hyderabad Spa Discounts | Online Restaurant Coupons | Good Shopping Reviews | Adventure Sports Tickets - Masthideals.com"
       elsif session[:city_id].to_s == '6'
          "Hot Deals on Spas, Restaurants, Movie Tickets, Jewellery in Delhi-NCR, India - Masthideals.com"
       elsif session[:city_id].to_s == '7'
          "Online Shopping Discounts on Pubs, Spas, Health, Hotels in Kolkata, India - Masthideals.com"   
       elsif session[:city_id].to_s == '8'
          "Daily Good Deals on Gyms, Beauty Salons, Food Coupons in Pune, India - Masthideals.com"
       elsif session[:city_id].to_s == '9'
          "Great Discount Deals on Hotels, Movies, Adventure Sports in Chandigarh, India - Masthideals.com"   
       end
    else
      @page_title
    end
  end   
  
  def meta(name, content)
    %(<meta name= "#{name}" content= "#{content} " />) 
  end
  
  def meta_description
    if @featured_product
      if @featured_product.meta_description      
        "#{@featured_product.meta_description}"
      end 
    else
      @description
    end
  end
  
  def meta_keywords
    if @featured_product
      if @featured_product.meta_keywords      
        "#{@featured_product.meta_keywords}"
      end 
    else
      @keywords
    end
  end
  
  
  def deal_live deal, product    
    if deal.sold_out==true or  product.deal_expiry_date<=Time.now      
      return false
    else     
      return true
    end
  end
  
   def admin?
    if current_user==User.first(:include => :roles, :conditions => ["roles.name = 'admin'"])
      return true
    else
      return false
    end
  end
  
  def deal_on product
    if product.currently_bought_count>=product.minimum_number
      return true
    else
      return false
    end
  end
  
   def get_states
    states=[]
    city = City.find(:first, :conditions => ['is_active = ? AND id = ?',  true, session[:city_id]])
    state = city.state
#    state=State.find(1061493609)
    states<<[state.name, state.id]
  end
  
  def get_countries
    countries=[]
    country = Country.find(92)
    countries<<[country.name, country.id]
  end
  
  def get_city_names
    cities=[]
    city=City.find(:all, :conditions => ['is_active = ? ',  true])
    city.each do |cty|
      cities<<[cty.name, cty.name]
    end
     cities 
  end
  
  def get_city_bill_address
    cities=[]
#    city=City.find_by_state_id(1061493609)
    city = City.find(:first, :conditions => ['is_active = ? AND id = ? ',  true,session[:city_id]])
#    city.each do |cty|
    cities << [city.name, city.id] 
#    end
    cities
  end
  
  def get_cities
    cities=[]
#    city=City.find_by_state_id(1061493609)
    city = City.find(:all, :conditions => ['is_active = ? ',  true])
    city.each do |cty|
      cities << [cty.name, cty.id]  
    end
    cities
  end
  
  def get_all_cities
    cities=[]
#    city=City.find_by_state_id(1061493609)
    city = City.find(:all)
    city.each do |cty|
      cities << [cty.name, cty.id]  
    end
    cities
  end
  
  
  def featured_product(order)
    #deal = DealHistory.find(:first, :conditions =>['is_active = ?', true])
    #Product.find(:first, :conditions => ['id = ?',deal.product_id])
     order.line_items[0].variant.product
  end

  def active_side_deal(side_deal_product_id)
    side_deal = Product.find(:first, :conditions => ['id = ? AND city_id = ?',side_deal_product_id,session[:city_id] ])
   return side_deal
  end
  
  def pay_affiliate_signup?(user)    
    if !user.affiliate_id.nil? and !user.paid_affiliate
      return true
#    elsif user.paid_affiliate
#      puts "to clear session........"
#      session[:affiliate]=nil
#      puts "after help.....#{session[:affiliate]}"
#      return false
    else
      return false
    end
  end
  
  def pay_affiliate_signup(user)
    user.paid_affiliate = true
    user.save
    session[:affiliate]=nil
  end
  
  def pay_affiliate_sale?(order)        
    if !order.affiliate_id.nil? and !order.paid_affiliate
      return true
#    elsif user.paid_affiliate
#      puts "to clear session........"
#      session[:affiliate]=nil
#      puts "after help.....#{session[:affiliate]}"
#      return false
    else
      return false
    end
  end
  
  def pay_affiliate_sale(order)
    order.paid_affiliate = true
    order.save
    session[:affiliate]=nil
  end
end
