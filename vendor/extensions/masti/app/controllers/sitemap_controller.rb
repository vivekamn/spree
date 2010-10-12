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
  
  def deals
    headers['Content-Type'] = 'text/xml; charset=utf-8'
    @deals = DealHistory.find(:all, :conditions =>['is_active = ? or is_side_deal= ?', true , true])
    product_ids = []
    product_ids = @deals.collect{|x| x.product_id}
    @products = Product.find(:all,:conditions=>['id in (?)', product_ids],:order=>"created_at")
    @last = DealHistory.find(:last)
     respond_to do |format|
      format.xml 
    end
  end
  
  def sub_deal
    headers['Content-Type'] = 'text/xml; charset=utf-8'
    @deal = DealHistory.find(:first, :conditions =>['is_side_deal = ? AND city_id = ?', true , params[:city_id]])
    @product = Product.find(@deal.product_id)
    respond_to do |format|
      format.xml 
    end  
  end
end
