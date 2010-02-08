module ActionView
  module Helpers
    module NumberHelper
      alias :rails_number_to_currency :number_to_currency
      def number_to_currency(number, options = {})
        @currency = options.delete(:currency) if options.key? :currency
        @currency ||= Currency.find(:first, :conditions => {:default => true})
        rails_number_to_currency(number, :unit => @currency.symbol)
      end
    end
  end
end