class SharedController < ApplicationController
 
   def plaxo_cb
    render :layout => false
  end
  
  def sms_deal_notify
 mobile_no = params[:mobile_no]
    mobile_no = mobile_no[-10..-1]
    if !params[:mobile_no].nil? and params[:mobile_no].length>=10 and params[:mobile_no].length<=13
       if params[:name].match(/^([a-z0-9._%+-]+)@((?:[-a-z0-9]+\.)+(?:[A-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)$)$/i)
         current_deal = DealHistory.find(:first, :conditions => "is_active = 1")
         product = Product.find(:first, :conditions =>"id = #{current_deal.product_id}")
         user = User.find(:first,:conditions=>['email = ? or phone_no= ?',params[:name],mobile_no])
         if user.nil?
           user = User.new(:email=>params[:name],:password=>"Test1234",:password_confirmation=>"Test1234",:phone_no=>mobile_no,:source=>"SMS")
           user.mobile_verify=true
           if user.save!
             UserPromotion.create(:credit_amount => 100, :user_id => user.id)
             UserMailer.deliver_success_sms_registration(user,product)
             message="Thanks for registering with MasthiDeals.com. Your username/ pwd is emailed to you. You have earned 100 Rs which you can use to buy any deal in Masthideals..com"
             send_sms(params[:mobile_no], message,100)
             redirect_to logout_url
          end
        else
           UserMailer.deliver_already_registered(user,product)
           message="You have already registered with us. Your Login for masthideal.com is #{ user.email }. Please Check your email id for further Details."
           send_sms(params[:mobile_no], message,100)
           redirect_to home_url
       end
       else
         sms_notify = SmsNotify.find_by_mobile_no(mobile_no)
          if sms_notify.nil?
            sms_notify = SmsNotify.new
            sms_notify.name = params[:name]
            sms_notify.mobile_no = mobile_no
            sms_notify.save
          end
          message = "Hi, Congrats! You have successfully registered with MasthiDeals.com. We will inform you about the new deals we lauch.For more details, please logon to www.masthideals.com - Lakshmi, MasthiDeals Team."
          send_sms(params[:mobile_no], message,100)
          redirect_to home_url
      end
    else
      redirect_to home_url
   end
  end
  
  def send_sms(phone_no,message,priority)
    query = "INSERT INTO jenooutbox (mobilenumber,message,priority) VALUES('#{ phone_no }','#{message}',#{priority});"
    result = ActiveRecord::Base.connection.execute(query)
  end
  
  def plaxo_invite
    recipients = params[:recipients]
    content = params[:body] 
    name = params[:name] 
#    count=recipients.split(",").count
#    count = current_user.invited_count
    if session[:src]=='/facebook' or session[:src]=='/orkut' or session[:src]=='/adwords' or session[:src]=='/email_camp' or session[:src]=='/email_camp_diff'
      money = 100
    else
      money = 50
    end
    if cookies[:email].nil?
      UserMailer.deliver_plaxo_invite(current_user.email,recipients,name,content,money)
    else
      UserMailer.deliver_plaxo_invite(cookies[:email],recipients,name,content,money)
    end
    cnt= "one"
    flash[:success] = "Thanks for inviting your friends to MasthiDeals.com"
    redirect_to reg_complete_path
  end
  
  def after_invite
    
  end
  
  def check_email_plaxo
    recipients = params[:recipients]
    @trimmed_line = recipients.delete(' ').lstrip
    split_recipients = @trimmed_line.split(",");    
    count = 0
    split_recipients.each do |s|        
      index_recipients = s.index('"')
      if index_recipients != nil 
        s = s.split('"')[1]
      end
      if(s.match(/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i))
          count+= 1;
      end
    end
    if(split_recipients.size == count)
      render(:text => "valid")
    else
      render(:text => "invalid")
    end
  end
  
end
