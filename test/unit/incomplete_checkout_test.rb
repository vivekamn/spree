require 'test_helper'

class IncompleteCheckoutTest < ActiveSupport::TestCase
  fixtures :gateways, :gateway_configurations
  
  context "incomplete checkout" do
    setup { @checkout = Factory(:incomplete_checkout) }
    context "with valid creditcard" do      
      setup { @checkout.creditcard = Factory.attributes_for(:creditcard) }                                           
      context "save with :auto_capture => false" do
        setup do
          @checkout.save
        end
        should_change "Creditcard.count", :by => 1
        should_change "CreditcardPayment.count", :by => 1
        should_change "CreditcardTxn.count", :by => 1
        should_change "@checkout.order.state", :from => 'in_progress', :to => 'new'
      end
      context "save with :auto_capture => true" do
        setup do
          Spree::Config.set(:auto_capture => true)
          @checkout.save
        end
        teardown { Spree::Config.set(:auto_capture => false) }
        should_change "Creditcard.count", :by => 1
        should_change "CreditcardPayment.count", :by => 1
        should_change "CreditcardTxn.count", :by => 1
        should_change "@checkout.order.state", :from => 'in_progress', :to => 'paid'
      end
    end
    context "save with declineable creditcard" do      
      setup do
        @checkout.creditcard = Factory.attributes_for(:creditcard, :number => "4111111111111110")
        begin @checkout.save rescue Spree::GatewayError end
      end
      should_not_change "Creditcard.count"
      should_not_change "CreditcardPayment.count"
      should_not_change "CreditcardTxn.count"          
      should_not_change "@checkout.order.state"
    end    
    context "with creditcard that fails validation" do
      setup do 
        @checkout.creditcard = {:number => "123"}
        @checkout.save
      end
      should_not_change "Creditcard.count"
      should_not_change "CreditcardPayment.count"
      should_not_change "CreditcardTxn.count"
    end
  end
end
