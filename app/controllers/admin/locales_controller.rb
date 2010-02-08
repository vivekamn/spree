class Admin::LocalesController < Admin::BaseController
  resource_controller

  update.wants.html { redirect_to collection_url }
  create.wants.html { redirect_to collection_url }

  update.before :update_before

  private
  def collection
    @collection ||= end_of_association_chain.find(:all, :order => :position)
  end

  def update_before
    params[:locale][:currency_ids] ||= []
  end
end
