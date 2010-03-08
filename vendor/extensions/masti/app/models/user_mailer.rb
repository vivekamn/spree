class UserMailer < ActionMailer::Base
  default_url_options[:host] = Spree::Config[:site_url]

  def password_reset_instructions(user)
    subject       Spree::Config[:site_name] + ' ' + I18n.t("password_reset_instructions")
    from          Spree::Config[:mails_from]
    bcc    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
  
  def users_deal_notify(recipients,product)
   from           "customersupport@masthideal.com"
   recipients     recipients
   subject        "New product in Masti Deal - #{product.name}" 
   sent_on        Time.now.utc
   body          "product" => product 
 end
 
  def notify_admin(user, product, msg)
    from           "customersupport@masthideal.com"
    recipients     user.email
    if msg == "deal_exp_notify"
      subject  "MasthiDeal: deal expiry notification"
    elsif msg == "deal_cancel_notify"
      subject  "MasthiDeal: deal cancel notification"
    elsif msg == "deal_on_notify"
      subject  "MasthiDeal: deal on notification"
    elsif msg == "deal_over_notify"
      subject  "MasthiDeal:  deal over notification"
    end
    sent_on        Time.now.utc
     body          "user" => user,"product"=>product
 end
 
 def notify_users_deal_cancel(user_emails, product)
    bcc user_emails
    from       "customersupport@masthideal.com"
    sent_on    Time.now.utc
    subject    "MasthiDeal: deal cancel notification" 
    body       "product" => product.name 
   
 end
 
 def users_notify_deal_on(user_emails, product)
    bcc        user_emails
    from       "customersupport@masthideal.com"
    sent_on    Time.now.utc
    subject    "MasthiDeal: deal on notification"
    body       "product" => product.name 
   
 end
 
 def users_notify_deal_over(user_emails, product)
    bcc        user_emails
    from       "customersupport@masthideal.com"
    sent_on    Time.now.utc
    subject    "MasthiDeal: deal_over_notification"
    body       "product" => product.name 
   
 end
 
end
