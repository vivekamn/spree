class SharedController < ApplicationController
  require 'csv' 
  require 'logger'


  DATA_DIRECTORY = File.join(RAILS_ROOT, "lib", "tasks", "sample")
 
   def dewali_contest
    if current_user
      cookies[:email] = current_user.email
    end
     if cookies[:email].nil?
      redirect_to get_email_path
     end
   end
 
  def get_email
    if !cookies[:email].nil?
      redirect_to dewali_contest_path
    end  
  end
  
  def user_answer
    user_answer = ActivePollUserAnswer.find(:all,:conditions=>["email = ? and active_poll_question_id = ?",cookies[:email],10110])
    if user_answer.nil? or user_answer.empty?
      ActivePollUserAnswer.create(:active_poll_question_id=>10110,:direct_answer=>params[:percent],:email=>cookies[:email])
      render(:text=>"success")
    else
      render(:text=>"failure")
    end
  end
  
  def api
   render :layout=>false
#   redirect_to "https://secure.ebs.in/pg/ma/sale/pay/?account_id=#{params[:account_id]}&return_url=#{params[:return_url]}&mode=#{params[:mode]}&reference_no=#{params[:reference_no]}&amount=#{params[:amount]}&description=#{params[:description]}&name=#{params[:name]}&address=#{params[:address]}&city=#{params[:city]}&state=#{params[:state]}&postal_code=#{params[:postal_code]}&country=#{params[:country]}&email=#{params[:email]}&phone=#{params[:phone]}&ship_name=#{params[:ship_name]}&ship_address=#{params[:ship_address]}&ship_city=#{params[:ship_city]}&ship_state=#{params[:ship_state]}&ship_postal_code=#{params[:ship_postal_code]}&ship_country=#{params[:ship_country]}&ship_phone=#{params[:ship_phone]}"
  end
 
 
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
  
  
  def diwali_crackers_list
    logger = Logger.new STDOUT
    logger.debug "loading diwali crackers list information  #{DATA_DIRECTORY} ..."
    Dir.glob("#{DATA_DIRECTORY}/deevali3.csv").each  do |file|
      diwali_crackers_list_file file
    end
    
    redirect_to home_url
  end
  
  def diwali_crackers_list_file file_name 
  logger = Logger.new STDOUT
  logger.debug "loading diwali crackers list information  #{file_name} ..."
  filename = File.join(file_name)
  CSV.open(filename, "r") do |row|
    next if row.size ==0 || row[1] == nil || row[1].blank? #empty lines are ignored
    next if row[0] == 'catergory' and row[1] == 'crackersname' and row[2] == 'unit' and row[3] == 'rate' 
    begin 
      variants = Variant.find(:first, :conditions => ['c_name = ? AND product_id = ? ', row[1],1060500648]) 
      if variants.nil?
        variants = Variant.new
        logger.debug "Added diwali crackers list information  for :  "+ row[1].to_s + "............."
      else
        logger.debug "Updated diwali cracker list information for : "+ variants.c_name.to_s + "------------"
      end
      variants.category = row[0]
      variants.c_name = row[1].capitalize
      variants.unit = row[2]
      variants.price = row[3]
      variants.product_id = 1060500648
      variants.count_on_hand = 100
      variants.image_url = row[4]
      variants.c_description = row[5]
      variants.save!
      query = "INSERT INTO option_values_variants (variant_id,option_value_id) VALUES (#{variants.id},979459986);"
      result = ActiveRecord::Base.connection.execute(query)
    rescue Exception => e
      logger.error "not able to load diwali cracker list " + row[1] + e.to_s
      next
    end
  end
  logger.debug "successfully Added diwali cracker list information ..............."
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
            message = "Hi, Congrats! You have successfully registered with MasthiDeals.com. We will inform you about the new deals we lauch.For more details, please logon to www.masthideals.com - Lakshmi, MasthiDeals Team."
            send_sms(params[:mobile_no], message,100)
          end
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
