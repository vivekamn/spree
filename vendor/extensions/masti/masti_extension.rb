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

    Image.attachment_definitions[:attachment][:styles] = {:mini => '48x48>', 
                                                          :small => '100x100>', 
                                                          :product => '240x240>',
                                                          :large => '400x400>'}

    UsersController.class_eval do
      def res
        require 'RubyRc4.rb'
        require 'base64'
        @key = 'ebskey'
        @DR = params[:DR]
        @DR.gsub!(/ /,'+')
        @encrypted_data = Base64.decode64(@DR)
        @decryptor = RubyRc4.new(@key)
        @plain_text = @decryptor.encrypt(@encrypted_data)
        puts "HTTP/1.0 200 OK"
        puts "Content-type: text/html\n\n"
        @plain_text.split(/&/).each_with_index do |item, i|
          key, val = item.split(/=/)
          puts "#{key}=#{val}"
        end
      end
    end

    



    # make your helper avaliable in all views
    # Spree::BaseController.class_eval do
    #   helper YourHelper
    # end
  end
end
