class Calculator::FlatRate < Calculator
  preference :amount, :decimal, :default => 0

  def self.description
    "Flat rate per order"
  end

  def self.available?(object)
    true
  end

  def compute(object=nil)
    self.preferred_amount
  end  
end
