module HomeHelper

  def progress_bar current_deal
      if current_deal.currently_bought_count>=current_deal.minimum_number
        bought_percent = 300
      else
          bought_percent = (current_deal.currently_bought_count*300)/current_deal.minimum_number
      end
  end

end
