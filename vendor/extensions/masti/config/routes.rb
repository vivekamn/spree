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
map.sitemap '/sitemap', :controller=>'home',  :action=>'sitemap'
map.upcoming '/upcoming-deals', :controller=>'home',  :action=>'upcoming_deals'
map.recent '/recent-deals', :controller=>'home',  :action=>'recent_deals'
map.forum '/forum',:controller => "home", :action => "index"
map.classifieds '/classifieds',:controller => "home", :action => "index"
map.directory '/directory',:controller => "home", :action => "index"
map.bookmarking '/bookmarking',:controller => "home", :action => "index"
map.blog '/blog',:controller => "home", :action => "index"
map.invite_friends '/invite-your-friends',:controller => "shared", :action => "invite"
map.verifiy_your_phone '/verifiy-your-phone',:controller => "home", :action => "verifiy_your_phone"
map.generate_code '/generate-code',:controller => "home", :action => "generate_code"
map.reg_complete '/registration-success',:controller => "home", :action => "index"
map.affliate '/affiliate',:controller => "shared", :action => "affliate"
map.refer_friends '/refer_friends',:controller => "shared", :action => "reffer_friends"
map.deal_preview '/deal_preview',:controller => "admin/deals", :action => "deal_preview"

#game urls
map.get_email '/get_email', :controller=>"shared", :action => "get_email"
map.dewali_contest '/dewali_contest', :controller=>"shared", :action => "dewali_contest"


# seo purpose & promotion
map.orkut '/orkut', :controller=>"home", :action => "index"
map.adwords '/adwords', :controller=>"home", :action => "index"
map.referral '/referral', :controller=>"home", :action => "cmom"
map.referral '/for_invite', :controller=>"home", :action => "cmom"
map.facebook '/facebook',:controller => "home", :action => "index"
map.email_camp '/email_camp',:controller => "home", :action => "index"

map.email_camp_blr '/email_camp_blr',:controller => "home", :action => "index", :city_id => 2
map.email_camp_hyd '/email_camp_hyd',:controller => "home", :action => "index", :city_id => 5

map.email_camp_diff '/email_camp_diff',:controller => "home", :action => "index"
map.email_camp_info '/email_camp_info', :controller => "home", :action => "index"
map.email_camp_tcs '/email_camp_tcs', :controller => "home", :action => "index"
map.email_camp_cts '/email_camp_cts', :controller => "home", :action => "index"
map.email_camp_polaris '/email_camp_polaris', :controller => "home", :action=>"index"
map.email_camp_eds '/email_camp_eds', :controller => "home", :action => "index"
map.email_camp_wipro 'email_camp_wipro', :controller => "home", :action => "index"
map.email_camp_flsmidth '/email_camp_flsmidth', :controller => "home", :action => "index"
map.email_camp_aircel '/email_camp_aircel', :controller => "home", :action => "index"
map.email_camp_ibm '/email_camp_ibm', :controller => "home", :action => "index"
map.email_camp_oracle '/email_camp_oracle', :controller => "home", :action => "index"
map.email_camp_hp '/email_camp_hp', :controller => "home", :action => "index"
map.email_camp_scope '/email_camp_scope', :controller => "home", :action => "index"
map.email_camp_ceequence '/email_camp_ceequence', :controller => "home", :action => "index"
map.email_camp_hcl '/email_camp_hcl', :controller => "home", :action => "index"
map.email_camp_steria '/email_camp_steria', :controller => "home", :action => "index"
map.email_camp_paypal '/email_camp_paypal', :controller => "home", :action => "index"

map.email_camp_bay_talkitec '/email_camp_bay_talkitec', :controller => "home", :action => "index"
map.email_camp_helios '/email_camp_helios', :controller => "home", :action => "index"
map.email_camp_impiger '/email_camp_impiger', :controller => "home", :action => "index"
map.email_camp_jeevan_technologies '/email_camp_jeevan_technologies', :controller => "home", :action => "index"
map.email_camp_scintel '/email_camp_scintel', :controller => "home", :action => "index"
map.email_camp_three_dot '/email_camp_three_dot', :controller => "home", :action => "index"
map.email_camp_computers_international '/email_camp_computers_international', :controller => "home", :action => "index"
map.email_camp_tychon '/email_camp_tychon', :controller => "home", :action => "index"
map.email_camp_openwave '/email_camp_openwave', :controller => "home", :action => "index"
map.email_camp_sword '/email_camp_sword', :controller => "home", :action => "index"
map.email_camp_owe '/email_camp_owe', :controller => "home", :action => "index"
map.email_camp_hexaware '/email_camp_hexaware', :controller => "home", :action => "index"
map.email_camp_virtusa '/email_camp_virtusa', :controller => "home", :action => "index"
map.email_camp_rrdonnelley '/email_camp_rrdonnelley', :controller => "home", :action => "index"
map.email_camp_isoft '/email_camp_isoft', :controller => "home", :action => "index"
map.email_camp_ideas2it '/email_camp_ideas2it', :controller => "home", :action => "index"
map.email_camp_zylog '/email_camp_zylog', :controller => "home", :action => "index"

#city path
map.chennai '/chennai', :controller=>'home', :action=>'index', :city_id => 1
map.hyderabad '/hyderabad', :controller=>'home', :action=>'index', :city_id => 5
map.bangalore '/bangalore', :controller=>'home', :action=>'index', :city_id => 2
map.delhi '/delhi', :controller=>'home', :action=>'index', :city_id => 6
map.mumbai '/mumbai', :controller=>'home', :action=>'index', :city_id => 3
map.kolkotta '/kolkotta', :controller=>'home', :action=>'index', :city_id => 7
map.pune '/pune', :controller=>'home', :action=>'index', :city_id => 8
map.chandigarh '/chandigarh', :controller=>'home', :action=>'index', :city_id => 9

#error path
map.error '/nodeal', :controller => 'home', :action=> 'error'

map.namespace :admin do |admin|
    admin.resources :products, :member => {:clone => :get}, :has_many => [:product_properties, :images] do |product|
      product.resources :variants
      product.resources :option_types, :member => { :select => :get, :remove => :get}, :collection => {:available => :get, :selected => :get}
      product.resources :taxons, :member => {:select => :post, :remove => :post}, :collection => {:available => :post, :selected => :get}
      product.resources :outlets
    end
   admin.resources :vendors
end 


map.order_failure 'orders/order_failure', :controller=>'orders', :action=>'failure'

map.connect "sitemap.xml", :controller => "sitemap", :action => "sitemap"
map.connect "deals.xml", :controller => "sitemap", :action => "deals"
map.rss_feed_deals '/current_deals.xml', :controller => 'sitemap', :action => 'current_deals', :format => 'rss'
map.rss_feed_deals_sunday '/current_deals_30sunday.xml', :controller => 'sitemap', :action => 'current_deals', :format => 'rss'
#map.connect "chennai_deal.xml", :controller => "sitemap", :action => "main_deal", :city_id => 1
#map.connect "bangaluru_deal.xml", :controller => "sitemap", :action => "main_deal", :city_id => 2
#map.connect "hyderabad_deal.xml", :controller => "sitemap", :action => "main_deal", :city_id => 5
#map.connect "chennai_sub_deal.xml", :controller => "sitemap", :action => "sub_deal", :city_id => 1
#map.connect "bangaluru_sub_deal.xml", :controller => "sitemap", :action => "sub_deal", :city_id => 2
#map.connect "hyderabad_sub_deal.xml", :controller => "sitemap", :action => "sub_deal", :city_id => 5
