module HasCalculator
	module ClassMethods
		def has_calculator(options = {})
      has_one   :calculator, :as => :calculable, :dependent => :destroy
      accepts_nested_attributes_for :calculator
      validates_presence_of(:calculator) if options[:require]

      if options[:default]
        default_calculator_class = options[:default]
        if default_calculator_class.available?(self.new)
          before_create :default_calculator
          define_method(:default_calculator) do
            self.calculator ||= default_calculator_class.new
          end
        else
          raise(ArgumentError, "calculator #{default_calculator_class} can't be used with #{self}")
        end
      else
        define_method(:default_calculator) do
          nil
        end
      end
      
      include InstanceMethods
    end
	end

	module InstanceMethods
		def calculator_attributes=(attributes)
      calculator_type = attributes.delete("calculator_type")
      if calculator_type
        if calculator_type == self.calculator.class.name
          self.calculator.update_attributes(attributes)
        else
          self.calculator = calculator_type.constantize.new
        end
      end
    end

    def calculator_attributes
      attr = self.calculator.attributes
      self.calculator.preferences.each_pair do |k,v|
        attr["preferred_#{k}"] = v
      end
      attr
    end
	end

	def self.included(receiver)
		receiver.extend         ClassMethods
	end
end
