require 'test_helper'

class CheckoutTest < ActiveSupport::TestCase
  fixtures :gateways, :gateway_configurations
  
  should_belong_to :bill_address
  should_belong_to :ship_address

  context "belonging to an order" do
    setup do
      @order = Factory(:order)
      @checkout = Checkout.new({
          :order => @order,
          :ship_address => Factory(:address),
          :bill_address => Factory(:address)
        })
    end
    should "not create shipping charge with no shipping method" do
      @checkout.save
      assert(@checkout.order.shipping_charges.empty?, "Shipping Charge was created")
    end

    context "with shipping method but without items" do
      setup do
        @shipping_method = Factory(:shipping_method)
        @checkout.shipping_method = @shipping_method
        @checkout.save 
      end
      
      should "increase shipping_charges by 1" do
        assert_equal 1, @checkout.order.shipping_charges.size
      end
      should "have the correct value for the new shipping charge" do
        assert_equal "0.0", @checkout.order.shipping_charges.first.amount.to_s
      end     
    end

    context "with shipping method and line_items" do
      setup do
        3.times do
          variant = Factory(:product).variants.first
          Factory(:line_item, :variant => variant, :order => @order)
        end
        @shipping_method = Factory(:shipping_method)
        @checkout.shipping_method = @shipping_method
        @checkout.save
      end

      should "increase shipping_charges by 1" do
        assert_equal 1, @checkout.order.shipping_charges.size
      end

      should "have the correct value for the new shipping charge" do
        assert_equal "10.0", @checkout.order.shipping_charges.first.amount.to_s
      end

      should_change "@checkout.order.charge_total", :by => 10

      context "and shipping amount changes" do
        setup do
          @shipping_method.calculator.update_attribute(:preferred_amount, 20)
          @checkout.save
        end
        should_not_change "@checkout.order.shipping_charges.count"
        should_change "@checkout.order.shipping_charges.first.amount", :from => 10, :to => 20
      end
    end
    
  end
end
