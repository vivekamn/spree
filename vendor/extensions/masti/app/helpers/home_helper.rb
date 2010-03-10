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

end
