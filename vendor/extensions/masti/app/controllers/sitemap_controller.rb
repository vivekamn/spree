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

end
