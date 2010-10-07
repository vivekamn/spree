class Admin::DealsController < ApplicationController

  def make_online
    city_id = params[:city_id]
    product=Product.find(params[:id])
#    side_deal = DealHistory.find(:first, :conditions => ['is_side_deal = ?', true])
    side_deal = DealHistory.find(:first, :conditions => ['is_side_deal = ? AND city_id = ?', true, city_id ])
    unless side_deal.nil?
      side_deal.is_side_deal = false
      side_deal.side_deal_completed_at = Time.now
      side_deal.save
    end
    
#    active_deal = DealHistory.find(:first, :conditions => ['is_active = ?', true])
    active_deal = DealHistory.find(:first, :conditions => ['is_active = ? AND city_id = ? ', true,city_id])
    unless active_deal.nil?
      active_deal.deal_completed_at = Time.now
      active_deal.side_deal_started_at = Time.now
      active_deal.is_active = false
      active_deal.is_side_deal = true
      active_deal.save!  
    end
    
    
    new_deal =DealHistory.new
    new_deal.product_id = product.id
    new_deal.deal_started_at = Time.now
    new_deal.is_active = 1
    new_deal.city_id = city_id
    new_deal.save
    new_deal.deal_notify(session[:city_id])
    redirect_to admin_products_url(:city_id => city_id)
  end
  
  def make_soldout
    product=Product.find(params[:id])
    active_deal = DealHistory.find(:first, :conditions => ['is_active = ? AND city_id =?', true, session[:city_id]])
#    active_deal = DealHistory.find(:first, :conditions => ['is_active = ?', true])
    active_deal.deal_completed_at = Time.now
    active_deal.sold_out = 1
    active_deal.save
    redirect_to admin_products_url(:flag=>'sold_out')
  end
  
  def sample_mail
    @product = Product.find_by_permalink(params[:id])
    render :layout => false
  end
  
  def manual_send_mail
    active_deal = DealHistory.find(:first, :conditions => ['is_active = ? AND city_id =? ', true, session[:city_id]])
    active_deal.deal_notify(session[:city_id])
    flash[:success]="successsfully sent"
    redirect_to admin_products_url
  end
  def manual_send_sms
    active_deal = DealHistory.find(:first, :conditions => ['is_active = ? AND city_id =?', true, session[:city_id]])
    active_deal.deal_notify(session[:city_id])
    flash[:success]="SMS Added"
    redirect_to home_url
  end
end
