class UserMailer < ActionMailer::Base
  helper "spree/base"
  default_url_options[:host] = Spree::Config[:site_url]

  def password_reset_instructions(user)
    subject       Spree::Config[:site_name] + ' ' + I18n.t("password_reset_instructions")
    from          Spree::Config[:mails_from]
    recipients    user.email
    bcc           Spree::Config[:mail_bcc]
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
  
  def success_invite(referer,count,user,current_user)
    content_type "text/html"
    from           "lakshmi@masthideals.com"
    recipients    referer
    bcc           Spree::Config[:mail_bcc]
    subject      "Thanks . You are close to winning the #{call_count(current_user)} Satyam tickets."
    sent_on        Time.now.utc
    body           "ref_email" => user,"count"=>count,"current_user"=>current_user
  end
  
  def plaxo_invite(from,recipients,name,body,money)
    content_type "text/html"
    from           from
    recipients    recipients
    bcc           Spree::Config[:mail_bcc]
    subject      "Become a part of MasthiDeals and earn #{money} MasthiDeals Money which you can use to buy any deal."
    sent_on        Time.now.utc
    body           "name" => name,"from"=>from,"body"=>body,"money"=>money
  end
  
  def share_this(recipient,from,product,name)
    content_type "text/html"
    from           from
    recipients    recipient
    bcc           Spree::Config[:mail_bcc]
    subject        "#{product.name}" 
    sent_on        Time.now.utc
    body           'product' => product,'name'=>name
  end
  
  def already_registered(user,product)
#   content_type "text/html"
    from           "customersupport@masthideals.com"
    recipients    user.email
    bcc           Spree::Config[:mail_bcc]
    subject        "Welcome to MasthiDeals community. You have already registered with us." 
    sent_on        Time.now.utc
    content_type    "multipart/alternative"
    part :content_type => "text/html",
        :body => render_message("already_registered", :product => product,:user=>user)
  end
 
  def success_sms_registration(user,product)
#   content_type "text/html"
    from           "customersupport@masthideals.com"
    recipients    user.email
    bcc           Spree::Config[:mail_bcc]
    subject        "Welcome to MasthiDeals community. Now you have 100 Rs to spend!" 
    sent_on        Time.now.utc
    content_type    "multipart/alternative"
    part :content_type => "text/html",
        :body => render_message("success_sms_registration", :product => product,:email=>user.email)
  end
  
  
  def registration(user,product)
    content_type "text/html"
    from           "customersupport@masthideals.com"
    recipients    user.email
    bcc           Spree::Config[:mail_bcc]
    subject        "Welcome to MasthiDeals community" 
    sent_on        Time.now.utc
    body           'product' => product
  end
  
  def users_deal_notify(recipients,product)
#   content_type "text/html"
   from           "customersupport@masthideals.com"
   bcc            recipients
   subject        "New product in Masti Deals - #{product.name}" 
   sent_on        Time.now.utc
   content_type    "multipart/alternative"
#   body          "product" => product,"url"=>default_url_options[:host]
    part :content_type => "text/html",
        :body => render_message("users_deal_notify", :product => product)
 end
 
  def notify_admin(user, product, msg)
    content_type "text/html"
    from           "customersupport@masthideal.com"
    recipients     user.email
    if msg == "deal_exp_notify"
      subject  "MasthiDeals: deal expiry notification"
    elsif msg == "deal_cancel_notify"
      subject  "MasthiDeals: deal cancel notification"
    elsif msg == "deal_on_notify"
      subject  "MasthiDeals: deal on notification"
    elsif msg == "deal_over_notify"
      subject  "MasthiDeals:  deal over notification"
    end
    sent_on        Time.now.utc
     body          "user" => user,"product"=>product,"vedor"=>product.vendor
 end
 
 def notify_users_deal_cancel(user_emails, product)
   content_type "text/html"
    bcc user_emails
    from       "customersupport@masthideals.com"
    sent_on    Time.now.utc
    subject    "MasthiDeals: deal cancel notification" 
    body       "product" => product.name 
   
 end
 
 def users_notify_deal_on(user_emails, product)
   content_type "text/html"
    bcc        user_emails
    from       "customersupport@masthideals.com"
    sent_on    Time.now.utc
    subject    "MasthiDeals: deal on notification"
    body       "product" => product.name 
   
 end
 
 def users_notify_deal_over(user_emails, product)
   content_type "text/html"
    bcc        user_emails
    from       "customersupport@masthideals.com"
    sent_on    Time.now.utc
    subject    "MasthiDeal: deal_over_notification"
    body       "product" => product.name 
   
 end
 
 def notify_credit_owed_to_admin(user, order)
   content_type "text/html"
    from           "customersupport@masthideal.com"
    recipients     user.email
    subject  "MasthiDeal: Credit Owed for a payment"
    sent_on        Time.now.utc
    body           "order"=>order
 end
 
 private
 def call_count(user)
   if user.is_cmom==true
     "two"
   else
    "one" 
   end
 end
 
end
