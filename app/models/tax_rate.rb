class TaxRate < ActiveRecord::Base
  belongs_to :zone
  belongs_to :tax_category
  has_calculator

  named_scope :by_zone, lambda { |zone| { :conditions => ["zone_id = ?", zone] } }
end
