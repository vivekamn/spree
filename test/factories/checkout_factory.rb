Factory.define(:checkout) do |record|
  record.email { Faker::Internet.email }
  record.special_instructions { Faker::Lorem.paragraphs(rand(5)+1).join("\n") }
  record.completed_at Time.now

  # associations: 
  record.association(:order)
  record.association(:shipping_method, :factory => :shipping_method)
  record.association(:bill_address, :factory => :address)
  record.association(:ship_address, :factory => :address)
end

###### ADD YOUR CODE BELOW THIS LINE #####

Factory.define :incomplete_checkout, :parent => :checkout do |f|
  f.completed_at nil
end