class Gateway::Linkpoint < Gateway
	preference :login, :string
	preference :pem, :string

  def provider
		@provider ||= ActiveMerchant::Billing::LinkpointGateway.new(self.options)  unless options.nil?
  end	
 
end