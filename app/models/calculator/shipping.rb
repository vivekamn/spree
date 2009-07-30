class Calculator::Shipping < Calculator
  def self.description
    "Special calculator for sipment costs"
  end

  def self.available?(object)
    object.respond_to?(:order) &&
      object.respond_to?(:shipping_method)
  end

  # Calculates shipping cost using calculators from shipping_rates and shipping_method
  # shipping_method calculator is used when there's no corresponding shipping_rate calculator
  #
  # shipping costs are calculated for each shipping_category - so if order have items
  # from 3 shipping categories, shipping cost will triple.
  # You can alter this behaviour by overwriting this method in your site extension
  def compute(source = nil)
    source ||= self.calculable

    rate_calculators = {}
    source.shipping_method.shipping_rates.each do |sr|
      rate_calculators[sr.shipping_category_id] = sr.caclualtor
    end
    default_calculator = source.shipping_method.calculator

    calculated_costs = source.order.line_items.group_by{|li|
      li.product.shipping_category_id
    }.map{ |shipping_category_id, line_items|
      calc = rate_calculators[shipping_category_id] || default_calculator
      calc.compute(line_items)
    }.sum

    return(calculated_costs)
  end
end