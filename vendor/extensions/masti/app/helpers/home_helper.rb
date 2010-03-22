module HomeHelper

  def progress_bar current_deal
      if current_deal.currently_bought_count>=current_deal.minimum_number
        bought_percent = 300
      else
          bought_percent = (current_deal.currently_bought_count*300)/current_deal.minimum_number
      end
  end
  
  def deal_live deal, product    
    if deal.sold_out==true or  product.deal_expiry_date<=Time.now      
      return false
    else     
      return true
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
    state=State.find(1061493609)
    states<<[state.name, state.id]
  end
  
  def get_countries
    countries=[]
    country = Country.find(92)
    countries<<[country.name, country.id]
  end
  
  def get_cities
    cities=[]
    city=City.find_by_state_id(1061493609)
    cities<<[city.name, city.name]
  end

end
