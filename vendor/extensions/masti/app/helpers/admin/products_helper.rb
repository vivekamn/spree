module Admin::ProductsHelper
  
  def current_product
    return DealHistory.find(:first, :conditions => ['is_active = ? and city_id = ?', true,session[:city_id]])
  end
  
  def option_type_select(so)
    select(:new_variant, 
           so.option_type.presentation, 
           so.option_type.option_values.collect {|ov| [ ov.presentation, ov.id ] })
  end

  def pv_tag_id(product_value)
    "product-property-value-#{product_value.id}"
  end

  def exclusive_properties(product, properties)
    product.property_values.each do |pv|
      properties.delete(pv.property)
    end
    properties
  end

end
