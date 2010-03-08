class Admin::DealsController < ApplicationController

  def make_online
    product=Product.find(params[:id])
    active_deal = DealHistory.find(:first, :conditions => ['is_active = ?', true])
    active_deal.deal_completed_at = Time.now
    active_deal.is_active = 0
    active_deal.save 
    new_deal =DealHistory.new
    new_deal.product_id = product.id
    new_deal.deal_started_at = Time.now
    new_deal.is_active = 1
    new_deal.save
    new_deal.deal_notify
    redirect_to admin_products_url
  end

end
