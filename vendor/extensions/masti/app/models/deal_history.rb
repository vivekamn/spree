class DealHistory < ActiveRecord::Base
  belongs_to :product
  def swith_off
    self.is_active=true
    self.save!
  end
  
  def sell_out   
    self.sold_out=true
    self.save!
  end
  
  def deal_notify    
    if (self.is_active == true)
      current_deal = DealHistory.find(:first, :conditions => "is_active = 1")
      product = Product.find(:first, :conditions =>"id = #{current_deal.product_id}")
      all_deals_notify_email = DealsNotification.find(:all, :select => "email")
      all_user_email = User.find(:all,:include => :roles,:select => "email", :conditions => ["roles.name = 'user' and is_sample = ?",false])
      message = product.sms_notification.to_s
      flag = 1
      qry_str = ""
     all_user_email.each do |user|
       unless user.phone_no.nil?
         if flag==1
            qry_str = "('#{ user.phone_no }','#{ message }')"
          else
            qry_str = qry_str + ", ('#{ user.phone_no }','#{ message }')"
          end
          flag = 2
        end
      end
      query = "INSERT INTO jenooutbox (mobilenumber,message) VALUES #{qry_str};"
      result = ActiveRecord::Base.connection.execute(query)
      all_emails = all_deals_notify_email.concat(all_user_email)
      all_emails = all_emails.uniq
      recipients = all_emails.collect{|x| x.email}.join(',')
      UserMailer.deliver_users_deal_notify(recipients, product)    
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