xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
 
xml.urlset(
	"xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
	"xsi:schemaLocation" => "http://www.sitemaps.org/schemas/sitemap/0.9",
       	:xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9"
	) do
  xml.url do
    xml.loc         "http://www.masthideals.com"
    xml.lastmod     Time.now.localtime.strftime("%Y-%m-%d")
    xml.changefreq  "always"
  end

  xml.url do
    xml.loc         "http://www.masthideals.com/how-masti-works"
    xml.lastmod     Time.now.localtime.strftime("%Y-%m-%d")
    xml.changefreq  "monthly"
  end
  
  xml.url do
    xml.loc         "http://www.masthideals.com/affiliate"
    xml.lastmod     Time.now.localtime.strftime("%Y-%m-%d")
    xml.changefreq  "monthly"
  end
  
  xml.url do
    xml.loc         "http://www.masthideals.com/faq"
    xml.lastmod     Time.now.localtime.strftime("%Y-%m-%d")
    xml.changefreq  "monthly"
  end 

 xml.url do
    xml.loc         "http://www.masthideals.com/user_session/new"
    xml.lastmod     Time.now.localtime.strftime("%Y-%m-%d")
    xml.changefreq  "monthly"
  end  
 xml.url do
    xml.loc         "http://www.masthideals.com/signup"
    xml.lastmod     Time.now.localtime.strftime("%Y-%m-%d")
    xml.changefreq  "monthly"
  end  

 xml.url do
    xml.loc         "http://www.masthideals.com/get-featured"
    xml.lastmod     Time.now.localtime.strftime("%Y-%m-%d")
    xml.changefreq  "monthly"
  end  

 xml.url do
    xml.loc         "http://www.masthideals.com/upcoming-deals"
    xml.lastmod     Time.now.localtime.strftime("%Y-%m-%d")
    xml.changefreq  "monthly"
  end  

 xml.url do
    xml.loc         "http://www.masthideals.com/about-us"
    xml.lastmod     Time.now.localtime.strftime("%Y-%m-%d")
    xml.changefreq  "monthly"
  end  

 xml.url do
    xml.loc         "http://www.masthideals.com/contact-us"
    xml.lastmod     Time.now.localtime.strftime("%Y-%m-%d")
    xml.changefreq  "monthly"
  end   

 xml.url do
    xml.loc         "http://www.masthideals.com/terms-conditions"
    xml.lastmod     Time.now.localtime.strftime("%Y-%m-%d")
    xml.changefreq  "monthly"
  end   

 xml.url do
    xml.loc         "http://www.masthideals.com/chennai"
    xml.lastmod     Time.now.localtime.strftime("%Y-%m-%d")
    xml.changefreq  "monthly"
  end   

# xml.url do
#    xml.loc         "http://www.masthideals.com/delhi"
#    xml.lastmod     Time.now.localtime.strftime("%Y-%m-%d")
#    xml.changefreq  "monthly"
#  end   
#
# xml.url do
#    xml.loc         "http://www.masthideals.com/mumbai"
#    xml.lastmod     Time.now.localtime.strftime("%Y-%m-%d")
#    xml.changefreq  "monthly"
#  end  
  
  xml.url do
    xml.loc         "http://www.masthideals.com/hyderabad"
    xml.lastmod     Time.now.localtime.strftime("%Y-%m-%d")
    xml.changefreq  "monthly"
  end 

 xml.url do
    xml.loc         "http://www.masthideals.com/bangalore"
    xml.lastmod     Time.now.localtime.strftime("%Y-%m-%d")
    xml.changefreq  "monthly"
  end   

 xml.url do
    xml.loc         "http://www.masthideals.com/login"
    xml.lastmod     Time.now.localtime.strftime("%Y-%m-%d")
    xml.changefreq  "monthly"
  end    

  @products.each do |product|
  xml.url do
    xml.loc         url_for(:controller => 'home',:action => 'product_preview',  :id => product.permalink, :only_path => false)
    xml.lastmod     Time.now.localtime.strftime("%Y-%m-%d")
    xml.changefreq  "monthly"
  end
  end    

end

