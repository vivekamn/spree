class ShippingMethod < ActiveRecord::Base
  belongs_to :zone
  has_many :shipping_rates

  has_calculator
   
  def calculate_shipping(shipment)
    shipment.calculate_shipping
  end   
  
  def available?(order)
    zone.include?(order.ship_address) &&
      calculator && calculator.available?(order)
  end
end
