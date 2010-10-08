xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'

  xml.deals do
    xml.provider do
      xml.icon "http://www.masthideals.com/favicon.ico"
      xml.logo "http://www.masthideals.com/images/logo.gif"
      xml.link "http://www.masthideals.com/"
    end
    xml.deal do
      xml.guid @product.id
      xml.link "http://www.masthideals.com/"
      xml.image "http://www.masthideals.com#{@product.images.first.attachment.url(:large)}"  
      xml.image_small "http://www.masthideals.com#{@product.images.first.attachment.url(:small)}"
      xml.title @product.name
      xml.description do 
        xml.cdata! @product.description.gsub(/<\/?[^>]*>/, "")
      end
      xml.terms do 
        xml.cdata! @product.catch_message.gsub(/<\/?[^>]*>/, "")
      end
      xml.type  "offline"
      xml.value  @product.master.price
      xml.discount @product.discount
      xml.category  
      xml.startdatetime @product.available_on
      xml.enddatetime  @product.deal_expiry_date
      xml.limitedperiod "Yes"
      xml.status  "Open"
      xml.coverage_area "50"
      xml.call_to_order "+91 44 43300051"
    end
    xml.merchant do
      xml.name @product.vendor.name
      xml.logo ""
      xml.description ""
      xml.category ""
    end
    xml.outlets do
      xml.outlet do
        xml.name @product.vendor.name
        xml.street_address @product.vendor.address.gsub(/<\/?[^>]*>/, "") unless @product.vendor.address.nil?
        xml.locality @product.vendor.city
        xml.region @product.vendor.state
        xml.country "India"
        xml.postal_code @product.vendor.zip
        xml.phones do
          xml.number "9841558555"
          xml.number " 044-455 300 50"
        end
      end
    end
    xml.reviews do
      xml.review do
        xml.description do 
          xml.cdata! @product.reviews.gsub(/<\/?[^>]*>/, "")
        end
      end
    end
  end


