class Outlet < ActiveRecord::Base
  belongs_to :product
  belongs_to :city
end
