xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'

xml.deals do
  xml.last_updated @last.updated_at
  xml.provider do
    xml.icon "http://www.masthideals.com/favicon.ico"
    xml.logo "http://www.masthideals.com/images/logo.gif"
    xml.link "http://www.masthideals.com/"
  end
  @products.each do |product|
    xml.deal do
      xml.guid product.id
      xml.link "http://www.masthideals.com/"
      xml.image "http://www.masthideals.com#{product.images.first.attachment.url(:large)}"  
      xml.image_small "http://www.masthideals.com#{product.images.first.attachment.url(:small)}"
      xml.title product.name
      xml.description do 
        xml.cdata! product.description.gsub(/<\/?[^>]*>/, "")
      end
      xml.terms do 
        xml.cdata! product.catch_message.gsub(/<\/?[^>]*>/, "")
      end
      xml.type  "offline"
      xml.value  product.master.price
      xml.discount product.discount
      xml.category product.category.nil? ? "" : product.category   
      xml.startdatetime product.available_on
      xml.enddatetime  product.deal_expiry_date
      xml.limitedperiod "Yes"
      xml.status  "Open"
      xml.coverage_area "10"
      xml.call_to_order "+91-44-43300051"
      xml.merchant do
        xml.name product.vendor.name
        xml.logo ""
        xml.description ""
        xml.category ""
      end
      xml.outlets do
        xml.outlet do
          xml.name product.vendor.name
          address_arr = ""
          address_arr = product.vendor.address.split('<br/>') unless product.vendor.address.nil?
          xml.street_address address_arr[0] unless address_arr.empty?
          xml.extended_address address_arr[1] unless address_arr[1].nil? or address_arr[1]== address_arr.last
          area = address_arr.empty? ? "" : address_arr.last.split(',')[0]
          city = product.vendor.city
          xml.locality "#{area},#{product.vendor.city}"
          xml.region product.vendor.state.name
          xml.postal_code product.vendor.zip
          xml.country "India"
          xml.geo do
            xml.latitude ""
            xml.longitude ""
          end
          xml.phones do
            xml.number "+91-9841558555"
            xml.number " +91-44-45530050"
          end
        end
        product.outlets.each do |outlet|
        xml.outlet do
          xml.name product.vendor.name
          xml.street_address outlet.address1
          xml.extended_address outlet.address2
          city = outlet.city
          xml.locality "#{outlet.area},#{city.name}"
          xml.region city.state.name
          xml.postal_code outlet.pincode
          xml.country "India"
          xml.geo do
            xml.latitude ""
            xml.longitude ""
          end
          xml.phones do
            xml.number outlet.contact_no
          end
        end
      end
      end
      xml.reviews do
        xml.review do
          xml.description do 
            xml.cdata! product.reviews.gsub(/<\/?[^>]*>/, "")
          end
        end
      end
    end
  end
end


