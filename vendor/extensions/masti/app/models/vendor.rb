class Vendor < ActiveRecord::Base
  has_many :products
  belongs_to :state
  #belongs_to :country
  validates_presence_of :name, :on => :save, :message => "required"
  validates_presence_of :contact_person_name, :on => :save, :message => "required"
  validates_numericality_of :phone_no, :on => :save, :message => "proper number required"
  validates_numericality_of :zip, :on => :save, :message => "proper code required"
  validates_uniqueness_of :name, :on => :save, :message => "already available, choose another"
  validates_format_of(:email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "not valid")
  validates_presence_of :state_id, :on => :save, :message => "required"
end
