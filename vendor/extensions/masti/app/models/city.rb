class City < ActiveRecord::Base
  belongs_to :state
  has_many :users
  has_many :deals_notifications
  has_many :sms_notifies
end
