class SharedController < ApplicationController
 
   def plaxo_cb
    render :layout => false
  end
  
  def invite
   if params[:flag].nil?
   if current_user or !cookies[:email].nil?
     if params[:from].nil?
        redirect_to refer_friends_path
     else
        redirect_to refer_friends_path(:from=>params[:from])  
     end
    end
   end
  end
  
  def reffer_friends
#    begin
#    email = params[:email].nil? ? current_user.email : params[:email]
    if !current_user.nil?
      @email = current_user.email
    elsif !params[:email].nil?
      @email = params[:email]
    elsif !cookies[:email].nil?
       @email = cookies[:email]     
    end
    unless @email.nil? or @email.empty?
      invited_count=0
      cookies[:email] = @email
      user = User.find_by_email(@email)
      unless user.nil?
        user_id = user.id
        invited_count = user.invited_count
      end
      @refferer = Refferer.find_by_email(@email)
      @refferer = Refferer.genarate_code(@email,invited_count,user_id) if @refferer.nil?
    else
       redirect_to '/shared/invite'
   end
 
#  rescue Exception => e
#     puts "#{e}--Exception from refer friends-->"
#      redirect_to '/shared/invite'
#    end
  end
  
  def affliate
    
  end
  
  def share_this_via_mobile
    message = Variant.find(params[:variant_id]).sms_share_text
    unless message.nil?
      mobile_nos = params[:mob_recipients].split(",")
      flag=1
      qry_str=""
      mobile_nos.each do |mobile_no|
        if flag==1
            qry_str = "('#{ mobile_no }','#{ message }',#{10})"
          else
            qry_str = qry_str + ", ('#{ mobile_no }','#{ message }',#{10})"
          end
          flag = 2
      end
      query = "INSERT INTO jenooutbox (mobilenumber,message,priority) VALUES #{qry_str};"
      result = ActiveRecord::Base.connection.execute(query)
      flash[:success]="Thanks for sharing this deal with your friends"
    end
    redirect_to :back
  end
  
  
  def create_affliate
    affliate = AffliateEnquiry.new(params[:affliate_enquiry])
    affliate.save!
    flash[:success]="Thanks for your interest in our Affiliate Partnership Program. Our corporate relationship executive will contact you soon."
    redirect_to :back
  end
  
  def unsubscribe
    user = User.find_by_email(params[:email])
    unless user.nil?
      user.unusbcribed = true
      user.save!
      @user_flag=true
    end
    deal_notify = DealsNotification.find_by_email(params[:email])
    unless deal_notify.nil?
       deal_notify.unusbcribed = true
       deal_notify.save!
       @notify_flag=true
    end
  end
  
  def sms_deal_notify
 mobile_no = params[:mobile_no]
    mobile_no = mobile_no[-10..-1]
    if !params[:mobile_no].nil? and params[:mobile_no].length>=10 and params[:mobile_no].length<=13
       if params[:name].strip.match(/^([a-z0-9._%+-]+)@((?:[-a-z0-9]+\.)+(?:[A-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)$)$/i)
         current_deal = DealHistory.find(:first, :conditions => "is_active = 1")
         product = Product.find(:first, :conditions =>"id = #{current_deal.product_id}")
         user = User.find(:first,:conditions=>['email = ? or phone_no= ?',params[:name],mobile_no])
         if user.nil?
           user = User.new(:email=>params[:name].strip.downcase,:password=>"Test1234",:password_confirmation=>"Test1234",:phone_no=>mobile_no)
           user.source="SMS"
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
    if session[:src]=='/facebook' or session[:src]=='/orkut' or session[:src]=='/adwords' or session[:src]=='/email_camp' or session[:src]=='/email_camp_diff' or session[:src] == '/email_camp_info' or session[:src] == '/email_camp_tcs' or session[:src] == '/email_camp_cts' or session[:src] == '/email_camp_polaris'
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
  
  def check_mobile_no
    recipients = params[:mobile]
    @trimmed_line = recipients.delete(' ').lstrip
    split_recipients = @trimmed_line.split(",");    
    count = 0
    split_recipients.each do |s|        
      if(s.match(/^([7-9]{1})([0-9]{9})+$/))
          count+= 1;
      end
    end
    if(split_recipients.size == count)
      render(:text => "valid")
    else
      render(:text => "invalid")
    end
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
