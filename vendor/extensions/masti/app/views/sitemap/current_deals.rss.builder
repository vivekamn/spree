xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
xml.rss :version => "2.0" do
  xml.channel do
    xml.timestamp Time.now.to_i
    xml.Merchant_ID("masthideals.com")
    
    @products.each do |product|
      xml.item do
        if request.request_uri=="/current_deals_30sunday.xml"
          xml.Category product.category.nil? ? "" : product.category  
        else
          xml.Category_ID product.category.nil? ? "3" : call_category_for_xml(product.category)
        end
        xml.Image_Link do
          xml.cdata! "http://www.masthideals.com#{product.images.first.attachment.url(:large)}"
        end 
        xml.Offer_Detail do
           xml.cdata! product.side_deal_title.nil? ? "" : product.side_deal_title
        end
        xml.Discount product.discount
        xml.Actual_Price  product.master.price
        xml.Saving(product.master.price - (product.master.price-((product.master.price*product.master.product.discount)/100)).to_i)
        if request.request_uri=="/current_deals_30sunday.xml"
          xml.City_ID City.find(product.city_id).name
        else
         xml.City_ID call_city_for_xml(product.city_id)
        end
        xml.Offer_Url do 
          if request.request_uri!="/current_deals_30sunday.xml"
            if product.city_id==1
              xml.cdata! "http://www.mustideals.com/idevaffiliate.php?id=107_15_1_49"  
            elsif product.city_id==2
              xml.cdata! "http://www.mustideals.com/idevaffiliate.php?id=107_16_1_51"
            else
              xml.cdata! "http://www.mustideals.com/idevaffiliate.php?id=107_17_1_50"
            end
          else
            if product.city_id==1
              xml.cdata! "http://www.mustideals.com/idevaffiliate.php?id=104_15_1_49"  
            elsif product.city_id==2
              xml.cdata! "http://www.mustideals.com/idevaffiliate.php?id=104_16_1_51"
            else
              xml.cdata! "http://www.mustideals.com/idevaffiliate.php?id=104_17_1_50"
            end
          end
         
        end
      end
    end
  end
end