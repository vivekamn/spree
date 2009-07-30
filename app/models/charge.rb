class Charge < ActiveRecord::Base
  acts_as_list :scope => :order
  
  belongs_to :order
  belongs_to :charge_source, :polymorphic => true

  validates_presence_of :amount
  validates_presence_of :description
  validates_numericality_of :amount

  before_save do |record|
    new_amount = record.calculate_charge
    record.amount = new_amount if new_amount
  end

  def calculate_charge
    if charge_source
      calc = charge_source.calculator || charge_source.default_calculator
      raise(RuntimeError, "#{self.class.name}##{id} doesn't have a calculator") unless calc
      calc.compute(charge_source)
    elsif read_attribute(:amount)
      read_attribute(:amount)
    else
      nil
    end
  end

  def amount
    read_attribute(:amount) || self.calculate_charge
  end
  
  def update_amount
    new_amount = calculate_charge
    update_attribute(:amount, new_amount) if new_amount
  end
end
