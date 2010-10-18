class LineItem < ActiveRecord::Base
  before_validation :adjust_quantity
  belongs_to :order
  belongs_to :variant
  
  has_one :product, :through => :variant

  before_validation :copy_price

  validates_presence_of :variant, :order
  validates_presence_of :quantity, :on => :save, :message => I18n.t("validation.must_be_present")
  validates_numericality_of :quantity, :only_integer => true, :message => I18n.t("validation.must_be_int")  
  validates_numericality_of :price

  attr_accessible :quantity, :variant_id, :order_id

  def copy_price
    self.price = variant.price if variant && self.price.nil?
  end  
 
  def validate
    @failure_status=[]
    unless quantity && quantity > 0
      errors.add(:quantity, I18n.t("validation.must_be_present"))
    end
    
    unless quantity && quantity >= 0
      errors.add(:quantity, I18n.t("validation.must_be_non_negative"))
    end
    # avoid reload of order.inventory_units by using direct lookup
#    unless Spree::Config[:allow_backorders]                               ||
#           order   && InventoryUnit.order_id_equals(order).first.present? || 
#           variant && quantity <= variant.on_hand                         
#      errors.add(:quantity, I18n.t("validation.is_too_large"))
#  end
  unless  order   && InventoryUnit.order_id_equals(order).first.present? || 
           variant && quantity <= variant.on_hand             
           @failure_status<<{:count => -(variant.on_hand-quantity)}           
      errors.add(:quantity, I18n.t("validation.is_too_large"))
    end
   unless variant.product.deal_expiry_date>Time.now
     @failure_status<<{:expired => variant.product.deal_expiry_date}
      errors.add(:product, "The deal has been expired. You cannot proceed")
    end
  end
  
  def increment_quantity
    self.quantity += 1
  end

  def decrement_quantity
    self.quantity -= 1
  end
  
  def total
    puts "line item price............#{self.price}"
    puts "line item quantity.........#{self.quantity}"
    self.price * self.quantity  
  end
  alias amount total
  
  def adjust_quantity    
    self.quantity = 0 if self.quantity.nil? || self.quantity < 0
  end
  
  def failure_status
    @failure_status
  end
end

