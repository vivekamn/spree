Factory.sequence(:zone_sequence) {|n| "Zone ##{n}"}

Factory.define(:zone) do |record|
  record.name { Factory.next(:zone_sequence) } 
  record.description { Faker::Lorem.sentence }
end
