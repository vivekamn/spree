# Put your extension routes here.
map.home '/', :controller => 'home'
map.root :controller => "home", :action => "index"
map.connect "update_assets", :controller => "home", :action => "update_assets"

# map.namespace :admin do |admin|
#   admin.resources :whatever
# end  
