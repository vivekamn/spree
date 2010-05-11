xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
 
xml.urlset(
	"xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
	"xsi:schemaLocation" => "http://www.sitemaps.org/schemas/sitemap/0.9",
       	:xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9"
	) do
  xml.url do
    xml.loc         "http://www.mastideals.com"
    xml.lastmod     Time.now.localtime.strftime("%Y-%m-%d")
    xml.changefreq  "always"
  end

  xml.url do
    xml.loc         "http://www.mastideals.com/how-masti-works"
    xml.lastmod     Time.now.localtime.strftime("%Y-%m-%d")
    xml.changefreq  "monthly"
  end

  xml.url do
    xml.loc         "http://www.mastideals.com/faq"
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

