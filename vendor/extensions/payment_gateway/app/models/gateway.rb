class Gateway < ActiveRecord::Base
	delegate_belongs_to :provider, :authorize, :purchase, :capture, :void, :credit
	
	validates_presence_of :name, :type
 
	@provier = nil
  @@providers = Set.new
  def self.register
    @@providers.add(self)
  end

  def self.providers
    @@providers.to_a
  end
 
	def validate
		errors.add_to_base I18n.translate("only_one_active_gateway_per_environment") if self.active && Gateway.exists?(:active => true, :environment => self.environment) 
	end
 
	def options
		options = {}
		self.preferences.each do |key,value| 
			next false if value.nil? || value.empty?

			options[key.to_sym] = value
		end
		
		options.length == preferences.length ? options : nil
	end
	
	def method_missing(method, *args)
	 	if @provider.nil?
			super
		else
			@provider.respond_to?(method) ? provider.send(method) : super
		end
	end
end
