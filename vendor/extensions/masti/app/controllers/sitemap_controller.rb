class SitemapController < ApplicationController

  session :off
  layout nil 

  def sitemap
    
    headers['Content-Type'] = 'text/xml; charset=utf-8'
    @products = Product.find(:all, :select => 'permalink', :conditions => ['deleted_at is NULL'])
    respond_to do |format|
      format.xml 
    end
  end
  
  def main_deal
    @deal = DealHistory.find(:first, :conditions =>['is_active = ? AND city_id = ?', true , params[:city_id]])
    @product = Product.find(@deal.product_id)
     respond_to do |format|
      format.xml 
    end
  end
  
  def sub_deal
    @deal = DealHistory.find(:first, :conditions =>['is_side_deal = ? AND city_id = ?', true , params[:city_id]])
    @product = Product.find(@deal.product_id)
    respond_to do |format|
      format.xml 
    end  
  end
end
