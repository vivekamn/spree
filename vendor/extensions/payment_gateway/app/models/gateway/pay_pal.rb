class Gateway::PayPal < Gateway
		preference :login, :string
		preference :password, :string
		preference :signature, :string
		preference :currency_code, :string

	  def provider
			@provider ||= ActiveMerchant::Billing::PaypalGateway.new(self.options)  unless options.nil?
	  end	

end