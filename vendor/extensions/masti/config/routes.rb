# Put your extension routes here.
map.resources :products, :member => {:change_image => :post}
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
map.payment_response '/payment_response' ,:controller=>"home",:action=>"payment_response"
map.chennai '/chennai', :controller=>'home', :action=>'index'
map.delhi '/delhi', :controller=>'home', :action=>'other_cities'
map.mumbai '/mumbai', :controller=>'home', :action=>'other_cities'
map.bangalore '/bangalore', :controller=>'home', :action=>'other_cities'
map.sitemap '/sitemap', :controller=>'home',  :action=>'sitemap'
map.upcoming '/upcoming-deals', :controller=>'home',  :action=>'upcoming_deals'
map.recent '/recent-deals', :controller=>'home',  :action=>'recent_deals'
map.forum '/forum',:controller => "home", :action => "index"
map.classifieds '/classifieds',:controller => "home", :action => "index"
map.directory '/directory',:controller => "home", :action => "index"
map.bookmarking '/bookmarking',:controller => "home", :action => "index"
map.blog '/blog',:controller => "home", :action => "index"
map.invite_friends '/invite-your-friends',:controller => "home", :action => "invite_friends"
map.verifiy_your_phone '/verifiy-your-phone',:controller => "home", :action => "verifiy_your_phone"
map.generate_code '/generate-code',:controller => "home", :action => "generate_code"
map.reg_complete '/registration-success',:controller => "home", :action => "index"

# seo purpose & promotion
map.orkut '/orkut', :controller=>"home", :action => "index"
map.adwords '/adwords', :controller=>"home", :action => "index"
map.referral '/referral', :controller=>"home", :action => "cmom"
map.referral '/for_invite', :controller=>"home", :action => "cmom"
map.facebook '/facebook',:controller => "home", :action => "index"
map.email_camp '/email_camp',:controller => "home", :action => "index"
map.email_camp_diff '/email_camp_diff',:controller => "home", :action => "index"
map.email_camp_info '/email_camp_info', :controller => "home", :action => "index"
map.email_camp_tcs '/email_camp_tcs', :controller => "home", :action => "index"
map.email_camp_cts '/email_camp_cts', :controller => "home", :action => "index"
map.email_camp_polaris '/email_camp_polaris', :controller => "home", :action=>"index"

map.namespace :admin do |admin|
   admin.resources :vendors
end  
map.order_failure 'orders/order_failure', :controller=>'orders', :action=>'failure'

map.connect "sitemap.xml", :controller => "sitemap", :action => "sitemap"
