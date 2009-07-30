Factory.sequence(:shipping_method_sequence) {|n| "ShippingMethod ##{n}"}

Factory.define(:shipping_method) do |record|
  record.calculator {|r| Factory(:calculator, :calculable => r.instance_eval{@instance}) }
  record.name { Factory.next(:shipping_method_sequence) } 

  # associations: 
  record.association(:zone)
end

Factory.define :calculator, :class => Calculator::FlatRate do |f|
  f.preferred_amount 10
end