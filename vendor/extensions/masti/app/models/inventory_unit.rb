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


def self.deal_status_update(order)
  begin
  order.line_items.each do |line_item|    
    product=line_item.variant.product
    old_count=product.currently_bought_count - line_item.quantity   
    if product.currently_bought_count>product.minimum_number and  old_count>product.minimum_number  
      logger.info "deal already on and trying to send confirmation mail"
      OrderMailer.deliver_confirm(order)      
    elsif product.currently_bought_count<product.minimum_number
      logger.info "deal not on and trying to send placement mail"
      OrderMailer.deliver_placed(order)
    elsif product.currently_bought_count==product.minimum_number or old_count<product.minimum_number 
      logger.info "deal on with this placement and trying to send confirmation mail"
      OrderMailer.deliver_confirm(order)
     end    

end
rescue Exception => e
  logger.error "problem sending order mails"+e.message
end

end

def self.sufficient_inventory(line_item)
  status="available"
      variant = line_item.variant
      quantity = line_item.quantity
      product=variant.product 
      current_deal=DealHistory.find_by_is_active(true)
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
   order.line_items.each do |line_item|      
      variant = line_item.variant
      quantity = line_item.quantity
      product=line_item.product
      current_deal=DealHistory.find_by_is_active(true)
      # mark all of these units as sold and associate them with this order
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
        variant.product.update_attribute(:currently_bought_count, bought)
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
