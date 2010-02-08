class Admin::CurrenciesController < Admin::BaseController
  resource_controller

  update.wants.html { redirect_to collection_url }
  create.wants.html { redirect_to collection_url }

  update.before :update_before

  private

  def update_before
    params[:currency][:locale_ids] ||= []
  end
end
