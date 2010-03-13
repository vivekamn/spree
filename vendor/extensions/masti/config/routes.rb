# Put your extension routes here.
map.home '/', :controller => 'home'
map.root :controller => "home", :action => "index"
map.connect "update_assets", :controller => "home", :action => "update_assets"
map.about_us '/about-us',:controller => "home", :action => "about_us"
map.how_masti_works '/how-masti-works',:controller => "home", :action => "how_masti_works"
map.faq '/faq',:controller => "home", :action => "faq"
map.get_featured '/get-featured',:controller=>"home",:action=>"get_featured"
map.contact_us '/contact-us',:controller=>"home",:action=>"contact_us"
map.progress_bar '/progress_bar',:controller=>"home",:action=>"progress_bar"
map.terms_conditions '/terms-conditions',:controller=>"home",:action=>"terms_conditions"
map.voucher '/voucher' ,:controller=>"home",:action=>"voucher"
map.chennai '/chennai', :controller=>'home', :action=>'index'
map.delhi '/delhi', :controller=>'home', :action=>'other_cities'
map.mumbai '/mumbai', :controller=>'home', :action=>'other_cities'
map.bangalore '/bangalore', :controller=>'home', :action=>'other_cities'
map.namespace :admin do |admin|
   admin.resources :vendors
end  
