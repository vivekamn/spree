class Admin::OutletsController < Admin::BaseController
  # GET /outlets
  # GET /outlets.xml
  resource_controller
  belongs_to :product
   
  private 
  def create_before 
  
  end
  
  def collection
    @deleted =  (params.key?(:deleted)  && params[:deleted] == "on") ? "checked" : ""
    
    if @deleted.blank?
      @collection ||= end_of_association_chain.find(:all)
    else
      @collection ||= end_of_association_chain.deleted.find(:all)
    end
  end
end
