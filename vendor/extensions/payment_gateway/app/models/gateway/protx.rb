class Gateway::Protx < Gateway
		preference :login, :string
		preference :password, :string
		preference :account, :string

	  def provider
			@provider ||= ActiveMerchant::Billing::ProtxGateway.new(self.options)  unless options.nil?
	  end	

end