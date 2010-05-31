module OrdersHelper  
  
  def order_price(order, options={})
    options.assert_valid_keys(:format_as_currency, :show_vat_text, :show_price_inc_vat)
    options.reverse_merge! :format_as_currency => true, :show_vat_text => true

    # overwrite show_vat_text if show_price_inc_vat is false
    options[:show_vat_text] = Spree::Config[:show_price_inc_vat]

    amount =  order.item_total
    amount += Calculator::Vat.calculate_tax(order) if Spree::Config[:show_price_inc_vat] 
    amount
    #options.delete(:format_as_currency) ? number_to_currency(amount) : amount
  end
  
  def get_quantities(variant,current_user)
    quantities = []
   unless variant.product.max_vouchers.nil?
       oreders = current_user.orders
        user_count = 0
        oreders.each do |order|
         order.line_items.each do |line_item|
           if line_item.variant.id ==  variant.id
             if order.state == "paid"
               user_count += line_item.quantity
             end
          end
         end
       end
       us_count = variant.product.max_vouchers - user_count
       us_count.times do |count|
        quantities << [count+1, count+1]
       end
   else
      variant.count_on_hand.times do |count|
        quantities << [count+1, count+1]
      end
   end
    return quantities  
  end

end