Factory.define :state do |f|
  f.name { Faker::Address.us_state }
  f.abbr { Faker::Address.us_state_abbr }
  f.country { Country.find_by_id(Spree::Config[:default_country_id]) || Country.find(:first) || Factory(:country) }
end

