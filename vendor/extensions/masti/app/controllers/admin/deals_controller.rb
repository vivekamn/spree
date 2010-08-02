class Admin::DealsController < ApplicationController

  def make_online
    product=Product.find(params[:id])
    
    side_deal = DealHistory.find(:first, :conditions => ['is_side_deal = ?', true])
    unless side_deal.nil?
      side_deal.is_side_deal = false
      side_deal.side_deal_completed_at = Time.now
      side_deal.save
    end
    
    active_deal = DealHistory.find(:first, :conditions => ['is_active = ?', true])
    active_deal.deal_completed_at = Time.now
    active_deal.side_deal_started_at = Time.now
    active_deal.is_active = false
    active_deal.is_side_deal = true
    active_deal.save!
    
    new_deal =DealHistory.new
    new_deal.product_id = product.id
    new_deal.deal_started_at = Time.now
    new_deal.is_active = true
    new_deal.save
    new_deal.deal_notify
    redirect_to admin_products_url
  end
  
  def make_soldout
    product=Product.find(params[:id])
    active_deal = DealHistory.find(:first, :conditions => ['is_active = ?', true])
    active_deal.deal_completed_at = Time.now
    active_deal.sold_out = 1
    active_deal.save
    redirect_to admin_products_url(:flag=>'sold_out')
  end
  
  def manual_send _mail
    active_deal = DealHistory.find(:first, :conditions => ['is_active = ?', true])
    active_deal.deal_notify
    flash[:success]="successsfully sent"
  end
  
end
