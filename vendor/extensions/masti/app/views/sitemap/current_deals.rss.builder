xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
xml.rss :version => "2.0" do
  xml.channel do
    xml.timestamp (Time.now).to_i
    xml.Merchant_ID("masthideals.com")
    
    @products.each do |product|
      xml.item do
        xml.Category_ID product.category.nil? ? "" : product.category 
        xml.Image_Link do
          xml.cdata! "http://www.masthideals.com#{product.images.first.attachment.url(:large)}"
        end 
        xml.Offer_Detail do
           xml.cdata! product.side_deal_title.nil? ? "" : product.side_deal_title
        end
        xml.Discount product.discount
        xml.Actual_Price  product.master.price
        xml.Saving(product.master.price - (product.master.price-((product.master.price*product.master.product.discount)/100)).to_i)
        xml.City_ID call_city_for_xml(product.city_id)
        xml.Offer_Url do 
          xml.cdata! "http://www.masthideals.com/home/product_preview/#{product.permalink}"
        end
      end
    end
  end
end