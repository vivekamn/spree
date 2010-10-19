class InventoryUnit < ActiveRecord::Base
  belongs_to :variant
  belongs_to :order
  belongs_to :shipment
  belongs_to :return_authorization

  named_scope :retrieve_on_hand, lambda {|variant, quantity| {:conditions => ["state = 'on_hand' AND variant_id = ?", variant], :limit => quantity}}

  # state machine (see http://github.com/pluginaweek/state_machine/tree/master for details)
  state_machine :initial => 'on_hand' do
    event :fill_backorder do
      transition :to => 'sold', :from => 'backordered'
    end
    event :ship do
      transition :to => 'shipped', :if => :allow_ship? #, :from => 'sold'
    end
    # TODO: add backorder state and relevant transitions
  end

  # destroy the specified number of on hand inventory units
  def self.destroy_on_hand(variant, quantity)
    inventory = self.retrieve_on_hand(variant, quantity)
    inventory.each do |unit|
      unit.destroy
    end
  end

  # create the specified number of on hand inventory units
  def self.create_on_hand(variant, quantity)
    quantity.times do
      self.create(:variant => variant, :state => 'on_hand')
    end
  end

  # grab the appropriate units from inventory, mark as sold and associate with the order
#  def self.sell_units(order)
#    out_of_stock_items = []
#    order.line_items.each do |line_item|
#      variant = line_item.variant
#      quantity = line_item.quantity 
#      product=variant.product
#      current_deal=DealHistory.find_by_is_active(true)
#      # mark all of these units as sold and associate them with this order
#      
#      if product.deal_expiry_date<Time.now
#         out_of_stock_items << {:line_item => line_item, :expired => 'true'}
#      
#    elsif variant.count_on_hand==0
#      out_of_stock_items << {:line_item => line_item, :sold_out => 'true'}
#      
#      
#      else
#      
#      remaining_quantity = variant.count_on_hand - quantity
#      if (remaining_quantity >= 0)
#        quantity.times do
#          order.inventory_units.create(:variant => variant, :state => "sold")
#        end
#        variant.update_attribute(:count_on_hand, remaining_quantity)        
#        product.update_attribute(:currently_bought_count,product.currently_bought_count+quantity)
#        if remaining_quantity==0
#          current_deal.sell_out
#        end
#       if product.currently_bought_count==product.minimum_number
#         
#       end
#        
#      else     
#        
#          line_item.update_attribute(:quantity, quantity + remaining_quantity)
#          out_of_stock_items << {:line_item => line_item, :count => -remaining_quantity}      
#        
#      end
#      end
#    end
#    
#    out_of_stock_items
#  end
  class << self
  def deal_status_update(order)
    product = order.line_items[0].variant.product
    user = User.find_by_email(order.email)
    begin    
      if product.id == 1060500648
        if order.state!='credit_owed'
          bought_count=product.currently_bought_count
          min_number = product.minimum_number
          if bought_count>min_number and  (bought_count-1)>min_number
            logger.info "deal already on and trying to send confirmation mail"
            message = "Hi ,We have emailed you the coupon for MasthiDeals - #{product.name}  - order no : #{order.number}."
            send_sms(user.phone_no,message)
            OrderMailer.deliver_voucher(order,product,order.user.email)
            if order.gift?
              message = "Hi, #{ order.checkout.bill_address.name } has gifted you #{ product.gift_sms }  Please check your email for further details."
              send_sms(order.giftee_phone_no,message)
              OrderMailer.deliver_gift_notification(order, product, product.master)
              OrderMailer.deliver_gift_voucher(order,product)
            end
          
         elsif bought_count<min_number
          logger.info "deal not on and trying to send placement mail"
          OrderMailer.deliver_placed(order,user)
          message = "Hi,Your order no : #{order.number}  for MasthiDeals - #{product.name} is successfuly placed. We will email you the voucher when the deals goes live.Order number : ( #{order.number})."
          send_sms(user.phone_no,message)
         elsif bought_count==min_number or (bought_count-1)<min_number
          logger.info "deal on with this placement and trying to send confirmation mail"
          OrderMailer.deliver_voucher(order,product,order.user.email)
          if order.gift?
              message = "Hi, #{ order.checkout.bill_address.name } has gifted you #{ product.gift_sms }  Please check your email for further details."
              send_sms(order.giftee_phone_no,message)
              OrderMailer.deliver_gift_notification(order, product, product.master)
              OrderMailer.deliver_gift_voucher(order,product)
          end  
           message = "Hi ,We have emailed you the coupon for MasthiDeals - #{product.name}  - order no : #{order.number}."
           send_sms(user.phone_no,message)
         end
       else
        OrderMailer.deliver_credit_owed(order)  
        logger.info "credit owed mailed to........." +order.email
        admin = User.first(:include => :roles, :conditions => ["roles.name = 'admin'"])
        UserMailer.deliver_notify_credit_owed_to_admin(admin, order)
        logger.info "and mailed to admin also........."
       end
      
        
        
        
        
        
      else              
      if order.state!='credit_owed'
        order.line_items.each do |line_item|
          variant =line_item.variant
          product=line_item.variant.product          
          old_count=product.currently_bought_count - line_item.quantity   
          if product.currently_bought_count>product.minimum_number and  old_count>product.minimum_number  
            logger.info "deal already on and trying to send confirmation mail"
            # we are sending vouchers after the deal is on
            message = "Hi ,We have emailed you the coupon for MasthiDeals - #{product.name}  - order no : #{order.number}."
            send_sms(user.phone_no,message)
            OrderMailer.deliver_voucher(order,product,order.user.email)
            if order.gift?
              message = "Hi, #{ order.checkout.bill_address.name } has gifted you #{ product.gift_sms }  Please check your email for further details."
              send_sms(order.giftee_phone_no,message)
              OrderMailer.deliver_gift_notification(order, product, variant)
              OrderMailer.deliver_gift_voucher(order,product)
            end
            
            #OrderMailer.deliver_confirm(order)      
          elsif product.currently_bought_count<product.minimum_number
            logger.info "deal not on and trying to send placement mail"
            user = User.find_by_email(order.email)
            OrderMailer.deliver_placed(order,user)
            message = "Hi,Your order no : #{order.number}  for MasthiDeals - #{product.name} is successfuly placed. We will email you the voucher when the deals goes live.Order number : ( #{order.number})."
            send_sms(user.phone_no,message)
          elsif product.currently_bought_count==product.minimum_number or old_count<product.minimum_number 
            logger.info "deal on with this placement and trying to send confirmation mail"
            #sending vouchers for all users before bought
            line_items_variant = variant.line_items
            # OrderMailer.deliver_notify_admin(product)
            line_items_variant.each do |item|
              if item.order.state == "paid"
                OrderMailer.deliver_voucher(item.order,product,item.order.user.email)
                if order.gift?
                  message = "Hi, #{ order.checkout.bill_address.name } has gifted you #{ product.gift_sms }  Please check your email for further details."
                  send_sms(order.giftee_phone_no,message)
                  OrderMailer.deliver_gift_notification(item.order, product, variant)
                  OrderMailer.deliver_gift_voucher(item.order,product)
                end  
                message = "Hi ,We have emailed you the coupon for MasthiDeals - #{product.name}  - order no : #{order.number}."
                send_sms(user.phone_no,message)
              end
            end
            # OrderMailer.deliver_confirm(order)
          end   
        end
      else
        OrderMailer.deliver_credit_owed(order)  
        logger.info "credit owed mailed to........." +order.email
        admin = User.first(:include => :roles, :conditions => ["roles.name = 'admin'"])
        UserMailer.deliver_notify_credit_owed_to_admin(admin, order)
        logger.info "and mailed to admin also........."
      end
      end
    rescue Exception => e
      logger.error "problem sending order mails"+e.message
    end
  end

  
    def send_sms(phone_no,message)
      query = "INSERT INTO jenooutbox (mobilenumber,message) VALUES('#{ phone_no }','#{message}');"
      result = ActiveRecord::Base.connection.execute(query)
    end
  end
  
def self.sufficient_inventory(line_item)
  status="available"
      variant = line_item.variant
      quantity = line_item.quantity
      product=variant.product 
      current_deal=DealHistory.find(:first, :conditions=>['product_id=? AND (is_active = ? OR is_side_deal = ?)',line_item.variant.product.id,true,true ])
      if product.deal_expiry_date<Time.now
        status="expired"
        current_deal.sell_out
      elsif variant.count_on_hand==0
        status= "sold_out"        
    else
      remaining_quantity = variant.count_on_hand - quantity
      if (remaining_quantity < 0)
        status="out_of_stock"
      end 
  end 
  logger.info "checking for sufficient quantity and result is "+status
  status      
end

 def self.sell_units(order)
   out_of_stock_items = []
   bought_count_flag = 0
   order.line_items.each do |line_item|      
      variant = line_item.variant
      quantity = line_item.quantity
      product=line_item.product
#      current_deal=DealHistory.find_by_is_active(true)
      # mark all of these units as sold and associate them with this order
      current_deal=DealHistory.find(:first, :conditions=>['product_id=? AND (is_active = ? OR is_side_deal = ?)',product.id,true,true ])
      remaining_quantity = variant.count_on_hand - quantity
      status=self.sufficient_inventory(line_item)
      if status=="available"
        logger.info "status is available and updating inventories"
        quantity.times do
          order.inventory_units.create(:variant => variant, :state => "sold")
        end        
        variant.update_attribute(:count_on_hand, remaining_quantity)        
        bought=variant.product.currently_bought_count+quantity        
        if remaining_quantity==0 
          logger.info "deal is going to be over and hence set sold out"
          current_deal.sell_out
        end
        if variant.product_id == 1060500648
          if bought_count_flag == 0
            puts "coming if"
            bought_count_flag = 1
            variant.product.update_attribute(:currently_bought_count, variant.product.currently_bought_count + 1)  
          end
        else
          variant.product.update_attribute(:currently_bought_count, bought)
        end
      elsif status=="out_of_stock"
#        (quantity + remaining_quantity).times do
#          order.inventory_units.create(:variant => variant, :state => "sold")
#        end        
          #line_item.update_attribute(:quantity, quantity + remaining_quantity)
          out_of_stock_items << {:line_item => line_item, :count => -remaining_quantity}        
      end
    end
    
    out_of_stock_items
  end 

  def can_restock?
    %w(sold shipped).include?(state)
  end

  def restock!
    variant.update_attribute(:count_on_hand, variant.count_on_hand + 1)
    variant.product.update_attribute(:currently_bought_count, variant.product.currently_bought_count-1)
    delete
  end

  # find the specified quantity of units with the specified status
  def self.find_by_status(variant, quantity, status)
    variant.inventory_units.find(:all,
                                 :conditions => ['status = ? ', status],
                                 :limit => quantity)
  end
  
  
  
  private
  
  
  def allow_ship?
    Spree::Config[:allow_backorder_shipping] || (state == 'ready_to_ship')
  end

end
