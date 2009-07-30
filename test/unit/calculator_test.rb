require 'test_helper'

class CalculatorTest < ActiveSupport::TestCase
  should_belong_to :calculable

  context "Calculator" do
    setup do
      [Calculator::FlatRate, Calculator::FlatPercent, Calculator::FlexiRate, Calculator::Shipping].each(&:register)
    end

    should "respond to .register" do
      assert Calculator.respond_to?(:register)
    end

    should "respond to .available?" do
      assert Calculator.respond_to?(:available?)
      assert Calculator.new.respond_to?(:available?)
    end

    should "find calculators available for kind of object" do
      assert_equal([
          Calculator::FlatRate,
          Calculator::FlatPercent,
          Calculator::FlexiRate,
          Calculator::PerItem,
        ].map(&:name).sort, Calculator.all_available_for(nil).map(&:name).sort)
    end
  end

  context "HasCalculator" do
    setup do
      @shipment = Factory(:shipment)
    end

    should "add calculator as has_one association" do
      assert Shipment.reflect_on_all_associations(:has_one).map(&:name).include?(:calculator)
    end

    should "add default calculator" do
      assert @shipment.calculator
    end

    should "provide calculator_type accessor" do
      assert @shipment.respond_to?(:calculator_type)
      assert @shipment.respond_to?(:calculator_type=)
    end

    teardown do
      @shipment && @shipment.destroy
    end
  end
end
