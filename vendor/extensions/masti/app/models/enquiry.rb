class Enquiry < ActiveRecord::Base
  validates_presence_of [:first_name, :last_name,:company,:phone_no,:city,:email]
#  validates_presence_of :last_name, :on => :save, :message => MessageSystem::CONFIG[:presence_enquiry_last_name_empty]
#  validates_presence_of :company, :on => :save, :message => MessageSystem::CONFIG[:presence_enquiry_company_empty]
#  validates_presence_of :phone_no, :on => :save, :message => MessageSystem::CONFIG[:presence_enquiry_phone_no_empty]
#  validates_presence_of :city, :on => :save, :message => MessageSystem::CONFIG[:presence_enquiry_city_empty]
#  validates_presence_of :email, :on => :save, :message => MessageSystem::CONFIG[:presence_enquiry_email_empty]
#  validates_presence_of :query, :on => :save, :message => MessageSystem::CONFIG[:presence_enquiry_query_empty]
  validates_format_of(:email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i)
#, :message => MessageSystem::CONFIG[:format_enquiry_email])
#  validates_numericality_of :phone_no, :on => :save, :message => MessageSystem::CONFIG[:numericality_enquiry_phone_no]
end
