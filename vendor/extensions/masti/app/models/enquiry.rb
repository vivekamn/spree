class Enquiry < ActiveRecord::Base
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :company
 # validates_presence_of :phone_no
  validates_presence_of :city
 # validates_presence_of :email
  validates_presence_of :query
  validates_length_of :phone_no, :is=>10
  validates_format_of(:email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i)
#, :message => MessageSystem::CONFIG[:format_enquiry_email])
#  validates_numericality_of :phone_no, :on => :save, :message => MessageSystem::CONFIG[:numericality_enquiry_phone_no]
end
