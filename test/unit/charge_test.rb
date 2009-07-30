require 'test_helper'

class ChargeTest < ActiveSupport::TestCase
  should_validate_presence_of :amount
  should_validate_presence_of :description
  context "order instance with charges" do
    setup do
      @order = Factory(:order)
      @order.tax_charges.first.update_attribute(:amount, 3.17)
      @order.update_totals
    end

    should "create default tax_charge" do
      assert_equal(1, @order.tax_charges.length)
      assert_equal(1, @order.charges.length)
      assert_equal(0, @order.shipping_charges.length)
    end

    should "have correct total" do
      assert_equal("3.17", @order.total.to_s)
    end

    context "when adding another charge" do
      setup do 
        Factory(:shipping_charge, :amount => 8.99, :order => @order)
        @order.save
      end
      
      should_change "@order.total", :by => BigDecimal("8.99")
      should_change "@order.charge_total", :by => BigDecimal("8.99")
      should_not_change "@order.item_total"
    end
    context "when adding another tax charge" do
      setup do 
        Factory(:tax_charge, :amount => 8.99, :order => @order)
        @order.update_totals
      end
      should "have 2 tax charges" do
        assert_equal(2, @order.tax_charges.reload.length)
      end
      should "have correct tax total" do
        assert_equal BigDecimal("12.16").to_s, @order.tax_total.to_s
      end
    end
    context "when destroying a charge" do
      setup do 
        @order.charges.clear
        @order.save
      end
      should_change "@order.total", :by => BigDecimal("-3.17")
      should_change "@order.charge_total", :by => BigDecimal("-3.17")
      should_not_change "@order.item_total"
    end
  end
end
