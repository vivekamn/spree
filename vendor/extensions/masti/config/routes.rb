# Put your extension routes here.
map.home '/', :controller => 'home'
map.root :controller => "home", :action => "index"
map.connect "update_assets", :controller => "home", :action => "update_assets"
map.about_us '/about-us',:controller => "home", :action => "about_us"
map.how_masti_works '/how-masti-works',:controller => "home", :action => "how_masti_works"
map.faq '/faq',:controller => "home", :action => "faq"
map.get_featured '/get-featured',:controller=>"home",:action=>"get_featured"
map.contact_us '/contact-us',:controller=>"home",:action=>"contact_us"

# map.namespace :admin do |admin|
#   admin.resources :whatever
# end  
