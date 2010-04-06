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
     {:name => 'location', :only => [:product]},        
  ]

    Product.class_eval do
      belongs_to :vendor
       attr_accessible :deal_expiry_date,:reviews,:currently_bought_count,:description, :catch_message, :validity_from, :validity_to, :name, :price, :sku, :count_on_hand, :available_on, :discount
      validates_presence_of :discount
      validates_presence_of :available_on
      validates_presence_of :minimum_number
      validates_presence_of :deal_expiry_date
      validates_presence_of :validity_from
      validates_presence_of :validity_to        
      validates_presence_of :vendor_id
      delegate_belongs_to :master, :count_on_hand
      validates_presence_of :count_on_hand       
      validate :minimum_less_than_maximum, :deal_expiry
      def minimum_less_than_maximum       
        if minimum_number and count_on_hand and count_on_hand>0          
          if count_on_hand<minimum_number           
            errors.add(:count_on_hand, "Minimum number should be less than Maximum number")
          end
        end
      end
      def deal_expiry        
        if deal_expiry_date<=Time.now
          errors.add(:deal_expiry_date, "should not be in past")
        end        
        if validity_from and validity_to and validity_from >= validity_to
          errors.add(:validity_from, "should be before validity_to date")
        end
      end
    end    
    
    
     User.class_eval do
       #attr_accessible :bill_address, :bill_address_attributes
       accepts_nested_attributes_for :bill_address      
      attr_accessible :phone_no
      validates_presence_of :phone_no
      validates_numericality_of :phone_no
      validates_length_of :phone_no, :is=>10
    end 

Address.class_eval do
  attr_accessible :name, :city, :state_id, :country, :address1, :zipcode, :phone
  has_one :user, :foreign_key => "bill_address_id"
      validates_presence_of :name
      validates_format_of :name, :with=>/^(([A-Za-z]+\s+[A-Za-z]+$)|([A-Za-z]+$))/
      #validates_presence_of :state
      validates_numericality_of :zipcode
      validates_numericality_of :phone
      #validates_length_of :phone, :is=>10
  end
  
  Transaction.class_eval do
    validates_uniqueness_of :original_creditcard_txn_id, :on=>:save, :message=>"Payment with this ID already exists"
  end
  
 AppConfiguration.class_eval do   
    preference :default_country_id, :integer, :default => 92
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
