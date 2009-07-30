require 'test_helper'

class CreditTest < ActiveSupport::TestCase
  should_validate_presence_of :amount     
  should_validate_numericality_of :amount
  should_validate_presence_of :description
  context "order instance with discounts" do
    setup do
      @order = Factory(:order)
      @credit = Factory(:credit, :amount => 2.00, :order => @order)
      @order.save
    end
    context "when adding another discount" do
      setup do
        Factory(:credit, :amount => 1.00, :order => @order)
        @order.save
      end
      
      should_change "@order.total", :by => BigDecimal("-1.00")
      should_change "@order.credit_total", :by => BigDecimal("1.00")
      should_not_change "@order.item_total"
    end
    context "when destroying a credit" do
      setup do 
        @order.credits.destroy_all
        @order.save
      end
      should_change "@order.total", :by => BigDecimal("2.00")
      should_change "@order.credit_total", :by => BigDecimal("-2.00")
      should_not_change "@order.item_total"
    end
  end  
end
