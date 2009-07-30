require 'test_helper'

class ShippingMethodTest < ActiveSupport::TestCase
  context "instance" do
    setup do 
      @shipping_method = Factory(:shipping_method)
      @calculator = @shipping_method.calculator
      @zone = @shipping_method.zone                 
      @shipment = Factory(:shipment)
      @order = @shipment.order
      variant = Factory(:product).variants.first
      @order.line_items << Factory(:line_item, :variant => variant)
    end
    context "when calculator indicates method is supported" do
      setup { 
        @zone.stub!(:include?, :return => true)
        @calculator.stub!(:available?, :return => true) 
      }
      should "be available" do
        assert @shipping_method.available?(@order)
      end
      context "when the shipping address falls within the method's zone" do
        setup { @zone.stub!(:include?, :return => true) }
        should "return the amount as calculated by the method's calculator" do
          assert_not_nil(@shipment.calculate_shipping)
          assert_equal "10.0", @shipment.calculate_shipping.to_s
        end      
      end
    end
    context "when calculator indicates method is not supported" do
      setup { @calculator.stub!(:available?, :return => false) }
      should "not be available" do
        assert !@shipping_method.available?(@order)
      end
    end
  end                 
end