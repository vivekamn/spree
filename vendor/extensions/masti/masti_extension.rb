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
    

    # make your helper avaliable in all views
    # Spree::BaseController.class_eval do
    #   helper YourHelper
    # end
  end
end
