class Variant < ActiveRecord::Base
  belongs_to :product
  delegate_belongs_to :product, :name, :description, :permalink, :available_on, :tax_category_id, :shipping_category_id, :meta_description, :meta_keywords

  has_many :inventory_units
  has_many :line_items
  has_and_belongs_to_many :option_values
  has_many :images, :as => :viewable, :order => :position, :dependent => :destroy
  has_many :prices, :dependent => :destroy

  validate :check_price
  validates_numericality_of :cost_price, :allow_nil => true

  before_save :touch_product

  # default variant scope only lists non-deleted variants
  named_scope :active, :conditions => "variants.deleted_at is null"
  named_scope :deleted, :conditions => "not variants.deleted_at is null"

  # default extra fields for shipping purposes
  @fields = [ {:name => 'Weight', :only => [:variant], :format => "%.2f"},
              {:name => 'Height', :only => [:variant], :format => "%.2f"},
              {:name => 'Width',  :only => [:variant], :format => "%.2f"},
              {:name => 'Depth',  :only => [:variant], :format => "%.2f"} ]

  #denotes if variant is priced in the default currency
  attr_reader :priced

  accepts_nested_attributes_for :prices, :reject_if => proc { |attrs| attrs['amount'].blank? }

  # mutli-currency aware price
  def price(currency=nil)
    currency = Currency.find(:first, :conditions => {:code => currency}) if currency.is_a? String
    currency ||= Currency.find(:first, :conditions => {:default => true}) if currency.nil?

    currency_price = prices.detect { |p| p.currency_id == currency.id }
    if currency_price.nil?
      if currency.default
        @priced = false
        amount = I18n.t('not_priced')
      else
        @priced = true
        amount ||= self.price() * currency.rate
      end
    else
      @priced = true
      amount ||= currency_price.amount
    end
  end

  # mutli-currency aware price setter (using default currency)
  def price=(amount)
    currency ||= Currency.find(:first, :conditions => {:default => true}) if currency.nil?
    set_price(amount, currency)
  end

  # mutli-currency aware price setter (with specific currency)
  def set_price(amount, currency)
    currency = Currency.find(:first, :conditions => {:code => currency}) if currency.is_a? String

    p = Price.find_or_initialize_by_currency_id_and_variant_id(currency.id, id)
    p.amount = amount
    prices << p if p.new_record?

    return p
  end

  # Returns number of inventory units for this variant (new records haven't been saved to database, yet)
  def on_hand
    self.count_on_hand
  end

  # Adjusts the inventory units to match the given new level.
  def on_hand=(new_level)
    delta_units = new_level.to_i - on_hand

    # increase Inventory when positive delta
    if delta_units > 0
      # fill backordered orders before creating new units
      inventory_units.with_state("backordered").slice(0, delta_units).each do |iu|
        iu.fill_backorder
        delta_units -= 1
      end
    end

    self.count_on_hand += delta_units
  end

  # returns number of units currently on backorder for this variant.
  def on_backorder
    inventory_units.with_state("backordered").size
  end

  # returns true if at least one inventory unit of this variant is "on_hand"
  def in_stock?
    on_hand > 0
  end
  alias in_stock in_stock?

  def self.additional_fields
    @fields
  end

  def self.additional_fields=(new_fields)
    @fields = new_fields
  end

  # returns true if this variant is allowed to be placed on a new order
  def available?
    Spree::Config[:allow_backorders] || self.in_stock?
  end

  def options_text
    self.option_values.map { |ov| "#{ov.option_type.presentation}: #{ov.presentation}" }.to_sentence({:words_connector => ", ", :two_words_connector => ", "})
  end

  def gross_profit
    self.cost_price.nil? ? 0 : (self.price - self.cost_price)
  end

  # use deleted? rather than checking the attribute directly. this
  # allows extensions to override deleted? if they want to provide
  # their own definition.
  def deleted?
    deleted_at
  end

  private

  # Ensures a new variant takes the product master price when price is not supplied
  def check_price
    if self.price.nil?
      raise "Must supply price for variant or master.price for product." if self == product.master
      self.price = product.master.price
    end
  end

  def touch_product
    product.touch unless is_master?
  end
end
