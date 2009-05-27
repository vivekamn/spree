class Admin::LayoutsController < Admin::BaseController
  resource_controller
=begin  
  create.response do |wants|
    wants.html { redirect_to collection_url }
  end

  update.response do |wants|
    wants.html { redirect_to collection_url }
  end
=end  
end