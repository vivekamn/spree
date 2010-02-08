class Price < ActiveRecord::Base
  belongs_to :variant
  belongs_to :currency
end
