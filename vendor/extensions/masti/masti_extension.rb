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
      attr_accessible :sms_share_text,:city_id,:star_discount,:side_deal_title,:gift_sms,:sms_notification,:max_vouchers,:meta_description,:meta_keywords,:deal_info,:voucher_text,:vendor_id,:minimum_number,:deal_expiry_date,:reviews,:currently_bought_count,:description, :catch_message, :validity_from, :validity_to, :name, :price, :sku, :count_on_hand, :available_on, :discount, :increased_count, :maximum_number
      attr_accessor :increased_count, :decreased_count
      validates_presence_of :deal_info
      validates_presence_of :side_deal_title
      validates_presence_of :voucher_text
      validates_presence_of :discount
      validates_presence_of :available_on
      validates_presence_of :minimum_number
      validates_presence_of :deal_expiry_date
      validates_presence_of :validity_from
      validates_presence_of :validity_to        
      validates_presence_of :vendor_id
      delegate_belongs_to :master, :count_on_hand,:sms_share_text
      validates_presence_of :count_on_hand       
      validate :minimum_less_than_maximum, :deal_expiry, :bought_count
      before_save :calc_count_on_hand
      def minimum_less_than_maximum       
        if minimum_number and maximum_number and maximum_number>0          
          if maximum_number < minimum_number           
            errors.add(:maximum_number, "Minimum number should be less than Maximum number")
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
      def bought_count
        if currently_bought_count > maximum_number
          errors.add(:currently_bought_count, "should be less than maximum number")
        else
          self.variant.count_on_hand = maximum_number - currently_bought_count
        end
      end
      def calc_count_on_hand
        if increased_count        
          #increased_count = 0 if increased_count.nil?
          #decreased_count||=0        
          #adjustment = increased_count.to_i
          self.count_on_hand = self.count_on_hand.to_i + increased_count.to_i
          self.maximum_number = self.maximum_number.to_i + increased_count.to_i       
        else        
          # self.count_on_hand = maximum_number.to_i
        end
      end
    end    
    
    State.class_eval do
      has_one :city
    end 
    
    User.class_eval do
      accepts_nested_attributes_for :bill_address
      attr_accessible :phone_no,:refered_by,:city_id
      has_one :verification_code
      has_one :user_promotion
      belongs_to :city
      has_one :refferer
      belongs_to :refferer
      after_create :call_count_mailer
      validates_numericality_of :phone_no, :message => "Phone No. must be numerals"
      validates_length_of :phone_no, :is=>10, :message => "is invalid"
      
      def call_count_mailer
        user_count = User.count(:conditions =>['is_sample != 1'])
        UserMailer.deliver_count_to_admin(user_count,self.email,"Masthideals",self.source,self.city.name)
      end
      
    end 
    
    Address.class_eval do
      attr_accessible :name, :city, :state_id, :country, :address1, :zipcode, :phone
      #  attr_accessor :name, :address1, :zipcode, :phone
      has_one :user, :foreign_key => "bill_address_id"
      validates_presence_of :name, :message => "can not be empty"      
      validates_format_of :name, :with=>/^([A-Za-z .]+$)/, :message => "is invalid"
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
                                                          :large => '540x540>'}
    
    
    
    
    
    # make your helper avaliable in all views
    Spree::BaseController.class_eval do
      helper HomeHelper
      before_filter :call_logging,:call_pop
      before_filter :set_city
      require 'geoip'
      def call_pop
        if cookies[:time_remaining].nil? and cookies[:asked_email].nil?
          cookies[:time_remaining]=10
        end
      end
      
      def set_city
        if session[:city_id].nil?
          begin
            db = GeoIP.new("#{RAILS_ROOT}/db/GeoLiteCity.dat") 
            city_by_ip = db.country(request.remote_ip)
            city = City.find_by_name(CITY_NAME[city_by_ip[7]]) if !city_by_ip.nil? and !city_by_ip[7].empty?
            if city.nil?
              session[:city_id] = 1
            else
              session[:city_id] = city.id
            end
          rescue Exception => e
            logger.info "Error in setting city -----------#{e.to_s}"
            session[:city_id] = 1
          end
        end
      end
      
      def call_logging
        #if session[:city_id].to_s == '1'
        url_split = request.request_uri.split('?')
        if session[:src].nil? and controller_name=="home" and action_name=="index" and request.request_uri!="/" and request.request_uri!="/registration-success" and request.request_uri!="/home" and request.request_uri!="/chennai" and url_split[0]!="/home/index" and url_split[0]!="/hyderabad" and url_split[0]!="/bangalore" and url_split[0]!="/"
          if url_split[1].nil? or url_split[1].empty? 
            session[:src]=request.request_uri
          else
            session[:src]=url_split[0]
          end
          #end
        end
        unless params[:email].nil?
          cookies[:email] = params[:email]
        end
        if current_user
          logger.info "#{current_user.email} is in Controller---> (#{controller_name}) action---> (#{ action_name}) Browser-----> (#{request.env["HTTP_USER_AGENT"]})"
        else
          logger.info "#{request.remote_ip} is in Controller---> (#{controller_name}) action---> (#{ action_name}) Browser-----> (#{request.env["HTTP_USER_AGENT"]})"
        end  
        
      end
    end
  end
end
