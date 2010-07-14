class Admin::DealsController < ApplicationController

  def make_online
    city_id = params[:city_id]
    product=Product.find(params[:id])
    active_deal = DealHistory.find(:first, :conditions => ['is_active = ? and city_id = ?', true, city_id ])
    unless active_deal.nil?
      active_deal.deal_completed_at = Time.now
      active_deal.is_active = 0
      active_deal.save 
    end
    new_deal =DealHistory.new
    new_deal.product_id = product.id
    new_deal.deal_started_at = Time.now
    new_deal.is_active = 1
    new_deal.city_id = city_id
    new_deal.save
    new_deal.deal_notify 
    redirect_to admin_products_url(:city_id => city_id)
  end
  
  
  def make_soldout
    product=Product.find(params[:id])
    active_deal = DealHistory.find(:first, :conditions => ['is_active = ? and city_id =?', true, session[:city_id]])
    unless active_deal.nil?
      active_deal.deal_completed_at = Time.now
      active_deal.sold_out = 1
      active_deal.save
      redirect_to admin_products_url(:flag=>'sold_out')
    else
      redirect_to admin_products_url
    end
  end

end
