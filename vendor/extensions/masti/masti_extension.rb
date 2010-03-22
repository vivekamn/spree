# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class MastiExtension < Spree::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/masti"

  # Please use masti/config/routes.rb instead for extension routes.

  # def self.require_gems(config)
  #   config.gem "gemname-goes-here", :version => '1.2.3'
  # end
  
  def activate

    Variant.additional_fields += [
     {:name => 'discount', :only => [:product]},
     {:name => 'minimum_number', :only => [:product]},
     {:name => 'currently_bought_count', :only => [:product]},
     {:name => 'deal_expiry_date', :only => [:product]},
     {:name => 'contact_info', :only => [:product]},
     {:name => 'validity_from', :only => [:product]},
     {:name => 'validity_to', :only => [:product]},
     {:name => 'catch_message', :only => [:product]},
     {:name => 'location', :only => [:product]}
  ]

    Product.class_eval do
      belongs_to :vendor
      validates_presence_of :discount
      validates_presence_of :available_on
      validates_presence_of :minimum_number
      validates_presence_of :deal_expiry_date
      validates_presence_of :validity_from
      validates_presence_of :validity_to
      validates_numericality_of :count_on_hand  
      validates_presence_of :vendor_id
      delegate_belongs_to :master, :count_on_hand
    end 
    
     User.class_eval do
       accepts_nested_attributes_for :bill_address      
      attr_accessible :phone_no
      validates_presence_of :phone_no
      validates_numericality_of :phone_no
      validates_length_of :phone_no, :is=>10
    end 

Address.class_eval do
  has_one :user, :foreign_key => "bill_address_id"
      validates_presence_of :name, :message=>"can't be blank" 
      validates_format_of :name, :with=>/^(([A-Za-z]+\s+[A-Za-z]+$)|([A-Za-z]+$))/, :message=>"cannot have non-alphabets other than space"
      validates_numericality_of :zipcode, :message=>"can't be anything else other than number"
    end


    Image.attachment_definitions[:attachment][:styles] = {:mini => '48x48>', 
                                                          :small => '100x100>', 
                                                          :product => '240x240>',
                                                          :large => '400x400>'}

 



    # make your helper avaliable in all views
     Spree::BaseController.class_eval do
       helper HomeHelper
     end
  end
end
