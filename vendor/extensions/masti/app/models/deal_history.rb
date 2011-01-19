class DealHistory < ActiveRecord::Base
  belongs_to :product
  def swith_off
    self.is_active=true
    self.save!
  end
  
  def self.send_sms(phone_no,message)
    query = "INSERT INTO jenooutbox (mobilenumber,message) VALUES('#{ phone_no }','#{message}');"
    result = ActiveRecord::Base.connection.execute(query)
  end
  
  def sell_out   
    self.sold_out=true
    self.save!
  end
  
  def deal_notify(city_id)
    if (self.is_active == true)
#      current_deal = DealHistory.find(:first, :conditions => "is_active = 1")
      current_deal = DealHistory.find(:first, :conditions =>['is_active = ? AND city_id = ?', true , city_id])
      product = Product.find(:first, :conditions =>"id = #{current_deal.product_id}")
      all_deals_notify_email = DealsNotification.find(:all, :select => "email",:conditions=>['unusbcribed = ? AND city_id = ?',false,city_id])
      all_user_email = User.find(:all,:include => :roles,:select => "email", :conditions => ["roles.name = 'user' and is_sample = ? and unusbcribed = ? AND city_id = ? ",false,false,city_id])
      message = product.sms_notification.to_s
      flag = 1
      qry_str = ""
    all_phone_nos = []
    all_phone_nos = all_user_email.collect{|x| x.phone_no}
    sms_mobile_no = []
    sms_nitifies = SmsNotify.find(:all, :conditions => ['city_id = ?', city_id])
    sms_mobile_no = sms_nitifies.collect{|x| x.mobile_no}
    all_phone_nos = all_phone_nos.concat(sms_mobile_no)
    all_phone_nos.uniq!
    all_phone_nos.each do |mobile|
         if flag==1
            qry_str = "('#{ mobile }','#{ message }')"
          else
            qry_str = qry_str + ", ('#{ mobile }','#{ message }')"
          end
          flag = 2
      end
      unless qry_str==""
        query = "INSERT INTO jenooutbox (mobilenumber,message) VALUES #{qry_str};"
        result = ActiveRecord::Base.connection.execute(query)
      end       
      all_emails = all_deals_notify_email.concat(all_user_email)
      all_emails = all_emails.uniq
      all_email_arr = []
      count=0
      all_emails.each do |all_email|
        all_email_arr << all_email
        if count==200
          recipients = all_email_arr.collect{|x| x.email}.join(',')
          UserMailer.deliver_users_deal_notify(recipients, product)
          all_email_arr=nil
          all_email_arr=[]
          count=0
        end
        count+=1
    end
#      recipients = all_email_arr.collect{|x| x.email}.join(',')
#      UserMailer.deliver_users_deal_notify(recipients, product)
#      recipients = all_emails.collect{|x| x.email}.join(',')
#      UserMailer.deliver_users_deal_notify(recipients, product)    
    end
  end
  
  
  def self.notify_admin_one_day_before
    current_deal = DealHistory.find(:first, :conditions => "is_active = 1")
    if current_deal && current_deal != nil
      product = Product.find(:first, :conditions =>"id = #{current_deal.product_id}")
      today = (Time.now.to_date).to_s
      one_day_before_deal_close = (product.deal_expiry_date.to_date - 1.day).to_s
      puts today
      puts one_day_before_deal_close
      admin = User.first(:include => :roles, :conditions => ["roles.name = 'admin'"])
      #admin = User.find(:first, :conditions => "role = 'Admin'")      
      if one_day_before_deal_close == today  
        puts "its coming"
        UserMailer.deliver_notify_admin(admin, product, "deal_exp_notify")
        puts "Deal expiry notification has been delivered to admin"
      end
    else
      puts "No deal is in active status"
    end
  end
   
  def self.notify_deal_closed
     current_deal = DealHistory.find(:first, :conditions => "is_active = 1")
    if current_deal && current_deal != nil
      product = Product.find(:first, :conditions =>"id = #{current_deal.product_id}")
      today = (Time.now.to_date).to_s
      deal_close_date = (product.deal_expiry_date.to_date).to_s
      puts today
      puts deal_close_date
       admin = User.first(:include => :roles, :conditions => ["roles.name = 'admin'"])      
      if deal_close_date == today
        variant=Variant.find(:first,:conditions=>['product_id = ? and is_master =? ',current_deal.product_id,1]);
        line_item=LineItem.find(:all,:select=>"order_id",:conditions => ["variant_id = ?",variant.id]);
        rec_list=[]
        line_item.each do |r|
           rec_list<<r.order_id
        end
        all_users=Checkout.find(:all,:select=>"email", :conditions => ['order_id in (?)',rec_list])
        user_emails=all_users.collect{|x| x.email}.join(',')
        if product.currently_bought_count < product.minimum_number
              msg = "deal_cancel_notify" 
              UserMailer.deliver_notify_users_deal_cancel(user_emails, product)
            else 
              if (product.maximum_number.nil?) or (product.currently_bought_count < product.maximum_number)
                msg = "deal_on_notify"
                UserMailer.deliver_users_notify_deal_on(user_emails, product)
              elsif product.currently_bought_count == product.maximum_number
                msg = "deal_over_notify"
                UserMailer.deliver_users_notify_deal_over(user_emails, product)
              end              
            end
          UserMailer.deliver_notify_admin(admin, product, msg)
          puts "#{msg} has been delivered to admin"
          puts "#{msg} has been delivered to - " + user_emails
    end
  end
end
   
 
end