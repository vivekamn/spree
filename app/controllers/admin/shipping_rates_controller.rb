class Admin::ShippingRatesController < Admin::BaseController
  resource_controller
  before_filter :load_data
  
  update.response do |wants|
    wants.html { redirect_to collection_url }
  end
  
  create.response do |wants|
    wants.html { redirect_to collection_url }
  end
    
  private 
  
  def load_data
    @available_shipping_methods = ShippingMethod.find(:all, :order => :name)
    @available_categories = ShippingCategory.find(:all, :order => :name)
    @calculators = Calculator.all_available_for(@object)
  end
end
