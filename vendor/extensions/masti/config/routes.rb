# Put your extension routes here.
map.resource :user_session, :member => {:nav_bar => :get}
  map.resource :account, :controller => "users"
  map.resources :password_resets
  
  map.login '/login', :controller => 'user_sessions', :action => 'new'
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.admin '/admin', :controller => 'admin/overview', :action => 'index'

map.home '/', :controller => 'home'
map.root :controller => "home", :action => "index"
map.connect "update_assets", :controller => "home", :action => "update_assets"
map.about_us '/about-us',:controller => "home", :action => "about_us"
map.how_masti_works '/how-masti-works',:controller => "home", :action => "how_masti_works"
map.faq '/faq',:controller => "home", :action => "faq"
map.get_featured '/get-featured',:controller=>"home",:action=>"get_featured"
map.contact_us '/contact-us',:controller=>"home",:action=>"contact_us"
map.progress_bar '/progress_bar',:controller=>"home",:action=>"progress_bar"
 map.resources :orders, :member => {:address_info => :get}, :has_many => [:line_items, :creditcards, :creditcard_payments]
  map.resources :orders, :member => {:fatal_shipping => :get} do |order|
    order.resources :shipments, :member => {:shipping_method => :get}
    order.resource :checkout, :member => {:register => :any}
  end
map.resources :products, :member => {:change_image => :post}
# Search routes
  map.simple_search '/s/*product_group_query', :controller => 'products', :action => 'index'
  map.pg_search '/pg/:product_group_name', :controller => 'products', :action => 'index'
  map.taxons_search '/t/*id/s/*product_group_query', {
    :controller => 'taxons',
    :action => 'show'
  }
  map.taxons_pg_search '/t/*id/pg/:product_group_name', {
    :controller => 'taxons',
    :action => 'show'
  }

  # route globbing for pretty nested taxon and product paths
  map.nested_taxons '/t/*id', :controller => 'taxons', :action => 'show'

  #moved old taxons route to after nested_taxons so nested_taxons will be default route
  #this route maybe removed in the near future (no longer used by core)
  map.resources :taxons
map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'  
  map.connect '*path', :controller => 'content', :action => 'show'
# map.namespace :admin do |admin|
#   admin.resources :whatever
# end  
