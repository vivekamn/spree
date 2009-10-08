class Gateway::AuthorizeNet < Gateway
	preference :login, :string
	preference :password, :string
	
  def provider
		@provider ||= ActiveMerchant::Billing::AuthorizeNetGateway.new(self.options) unless options.nil?
  end


end