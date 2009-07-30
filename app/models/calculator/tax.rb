class Calculator::Tax < Calculator
  def self.description
    "Special calculator for taxes"
  end

  def self.available?(object)
    object.is_a?(Order)
  end

  # Computes a vat and sales tax for _order_ based on tax rates associated with zones
  def compute(order = nil)
    order ||= self.calculable
    # tax is zero if ship address does not match any existing tax zone
    tax_rates = TaxRate.all.find_all { |rate| rate.zone.include?(order.ship_address) }
    if tax_rates.empty?
      return()
    else
      sales_tax_rates = tax_rates.find_all { |rate| rate.tax_type == TaxRate::TaxType::SALES_TAX }
      vat_rates = tax_rates.find_all { |rate| rate.tax_type == TaxRate::TaxType::VAT }

      # note we expect only one of these tax calculations to have a value but its technically possible to model
      # both a sales tax and vat if you wanted to do that for some reason
      sales_tax = Calculator::SalesTax.calculate_tax(order, sales_tax_rates)
      vat_tax = Calculator::Vat.calculate_tax(order, vat_rates)

      return(sales_tax + vat_tax)
    end
  end
end