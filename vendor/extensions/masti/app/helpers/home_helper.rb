module HomeHelper

  def progress_bar current_deal
      if current_deal.currently_bought_count>=current_deal.minimum_number
        bought_percent = 300
      else
          bought_percent = (current_deal.currently_bought_count*300)/current_deal.minimum_number
      end
  end
  
   def page_title
     if @featured_product
        "Daily Deals in Chennai | Cheap Deals Discount | Great Discount Coupons | Best Deals Website - Masthideals.com"
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
  
#   def get_states
#    states=[]
#    state=current_user.city.state
#    states<<[state.name, state.id]
#  end
  
#  def get_countries
#    countries=[]
#    country = Country.find(92)
#    countries<<[country.name, country.id]
#  end
  
  def get_cities
    cities=[]
#    city=City.find_by_state_id(1061493609)
    city = City.find(:all, :conditions => ['is_active = ?',  true])
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
  
  def featured_product
    deal = DealHistory.find(:first, :conditions =>['is_active = ?', true])
    Product.find(:first, :conditions => ['id = ?',deal.product_id])
  end

end
