class SitemapController < ApplicationController

  
  layout nil 

  def sitemap
    session :off
    headers['Content-Type'] = 'text/xml; charset=utf-8'
    @products = Product.find(:all, :select => 'permalink', :conditions => ['deleted_at is NULL'])
    respond_to do |format|
      format.xml 
    end
  end
  
  def main_deal
    unless params[:city_id].nil?
      session[:city_id] = params[:city_id]
    end
    @deal = DealHistory.find(:first, :conditions =>['is_active = ? AND city_id = ?', true , session[:city_id]])
    @product = Product.find(@deal.product_id)
     respond_to do |format|
      format.xml 
    end
  end
  
  def sub_deal
    unless params[:city_id].nil?
      session[:city_id] = params[:city_id]
    end
    @deal = DealHistory.find(:first, :conditions =>['is_side_deal = ? AND city_id = ?', true , session[:city_id]])
    @product = Product.find(@deal.product_id)
    respond_to do |format|
      format.xml 
    end  
  end
end
