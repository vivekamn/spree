class Checkout < ActiveRecord::Base  
  before_save :authorize_creditcard, :unless => "Spree::Config[:auto_capture]"
  before_save :capture_creditcard, :if => "Spree::Config[:auto_capture]"
  after_save :process_coupon_code
  after_save :update_charges_and_credits

  has_one    :charge,   :as => :charge_source
  belongs_to :order
  belongs_to :shipping_method
  belongs_to :bill_address, :foreign_key => "bill_address_id", :class_name => "Address"
  belongs_to :ship_address, :foreign_key => "ship_address_id", :class_name => "Address"
  has_calculator :default => Calculator::Shipping

  accepts_nested_attributes_for :ship_address, :bill_address

  # for memory-only storage of creditcard details
  attr_accessor :creditcard    
  attr_accessor :coupon_code

  private
  def authorize_creditcard
    return unless process_creditcard? 
    cc = Creditcard.new(creditcard.merge(:address => self.bill_address, :checkout => self))
    return unless cc.valid? and cc.authorize(order.total)
    order.complete
  end

  def capture_creditcard
    return unless process_creditcard? 
    cc = Creditcard.new(creditcard.merge(:address => self.bill_address, :checkout => self))
    return unless cc.valid? and cc.purchase(order.total)
    order.complete
    order.pay
  end

  def process_creditcard?
    order and creditcard and not creditcard[:number].blank?
  end

  def process_coupon_code
    return unless @coupon_code and coupon = Coupon.find_by_code(@coupon_code.upcase)
    coupon.create_discount(order)
  end

  def create_temporary_shipping_charge
    if shipping_method
      self.charge ||= ShippingCharge.create({
          :order => order,
          :description => "#{I18n.t(:shipping)} (#{shipping_method.name})",
          :charge_source => self,
        })
    end
  end

  def update_charges_and_credits
    create_temporary_shipping_charge
    #order.update_totals
    order.save
  end
end
