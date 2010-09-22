class SharedController < ApplicationController
  
  def plaxo_cb
    render :layout => false
  end
  
  def affliate_user_question
    unless params[:product_id].nil? and cookies[:email].nil?
      product = Product.find(params[:product_id])
      @question = product.active_poll_question
      user_answer = ActivePollUserAnswer.find(:all,:conditions=>["email = ? and active_poll_question_id = ?",cookies[:email],@question.id])
      if !user_answer.nil? and !user_answer.empty?
        flash[:error] = "Youy have already Answered......."
        redirect_to home_url
      end
      @options = @question.active_poll_answers
    else
      redirect_to home_url
    end
  end
  
  def check_if_lucky
    user_answer = ActivePollUserAnswer.find(:all,:conditions=>["email = ? and active_poll_question_id = ?",cookies[:email],params[:qusetion_id]])
    if user_answer.nil? or user_answer.empty?
      user_answer = ActivePollUserAnswer.new(:active_poll_question_id=>params[:qusetion_id],:active_poll_answer_id=>params[:answer][:user_answer],:email=>cookies[:email])
      question = ActivePollQuestion.find(params[:qusetion_id])
      luck_no = [6,15,24,33,42,3,5,8,27,30]
      user_no = rand(50)
      logger.info "#{user_no}"
#      user_no = 15
      got_price = luck_no.include?(user_no)
      user = User.find_by_email(cookies[:email])
      price_got_count = ActivePollUserAnswer.count(:all,:conditions=>["price_no = ? and active_poll_question_id = ?",user_no,params[:qusetion_id]])
      if got_price and (price_got_count.nil? or price_got_count<1)
        user_answer.price_no = user_no
        user_answer.save!
        if user.nil?
          credit_points(cookies[:email],50,user)
          redirect_to "/shared/tip?phone_no=true&user_answer=#{user_answer.id}"
        else
          credit_md_money(user,question.product)          
        end
      else
        user_answer.save!
        credit_points(cookies[:email],10,user)   
        redirect_to "/shared/tip?user_answer=#{user_answer.id}"
      end
      
    else
      flash[:error] = "Youy have already Answered......."
      redirect_to :home
    end
  end
  
  def tip
    unless params[:user_answer].nil?
      @user_answer = ActivePollUserAnswer.find(params[:user_answer])
      @question = ActivePollQuestion.find(@user_answer.active_poll_question_id)
      user = User.find_by_email(@user_answer.email)
      if user.nil?
        @user_promotion = UserPromotion.find_by_email(@user_answer.email)
      else
        @user_promotion = UserPromotion.find(:first,:conditions=>['user_id = ? or email= ? ',user.id,@user_answer.email])
        if @user_promotion.points>=50
          credit_md_money(user,@question.product,@user_answer.email)
        end
      end
    end
  end
  
  def update_md_money
    user = User.find(:first,:conditions=>['email = ? or phone_no= ?',cookies[:email],params[:user][:mobile_no]])
    question = ActivePollQuestion.find(params[:question_id])
    if user.nil? or user.empty?
      user = User.new(:email=>cookies[:email].strip.downcase,:password=>"Test1234",:password_confirmation=>"Test1234",:phone_no=>params[:user][:mobile_no])
      user.save!
      user_promotion =  UserPromotion.find_by_email(user.email)
      params[:email_to_send] = user_promotion.nil? ? params[:email_to_send] : true
      unless params[:email_to_send]
        credit_md_money(user,question.product)
      else
        credit_md_money(user,question.product,cookies[:email])
      end
      
    else
      flash[:Error] = "Some Error Message------->"
      redirect_to home_url  
    end
  end
  
  def credit_points(email,points,user=nil)
    unless user.nil?
      user_promotion = UserPromotion.find(:first,:conditions=>['user_id = ? or email= ? ',user.id,email])
      if user_promotion.nil?
        user_promotion = UserPromotion.create(:points => points, :user_id => user.id)
      else
        user_promotion.update_attributes(:points => user_promotion.points+points)            
      end
    else
      user_promotion = UserPromotion.find_by_email(email)
      if user_promotion.nil?
        user_promotion = UserPromotion.create(:points => points, :email => email) 
      else
        user_promotion.update_attributes(:points => user_promotion.points+points)            
      end
    end
    #    check_points_to_give_md_money(user_promotion)
  end
  
  def credit_md_money(user,product,email=nil)
    user_promotion = UserPromotion.find(:first,:conditions=>['user_id = ? or email= ? ',user.id,email])   
    promotion_obj = UserPromotion.find_by_user_id(user.id)
    if user_promotion.nil?
      UserPromotion.create(:credit_amount => 50, :user_id => user.id)
    else
      user_promotion.credit_amount = 0 if user_promotion.credit_amount.nil?
      user_promotion.update_attributes(:credit_amount => user_promotion.credit_amount+(50 * ((user_promotion.points/50).to_i)),:points=> user_promotion.points>=50 ? user_promotion.points-(50 * ((user_promotion.points/50).to_i)) : 0,:user_id=>user.id)            
    end
    UserMailer.deliver_success_sms_registration(user,product)
    message="Thanks for registering with MasthiDeals.com. Your username/ pwd is emailed to you. You have earned 50 Rs which you can use to buy any deal in Masthideals..com"
    send_sms(params[:mobile_no], message,100)
    flash[:success] = "Hurry You got 50 MD Money Right now....."
    redirect_to home_url  
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
    message = "Hi #{params[:name]} has shared a Deal information for you from masthideals.com. "
    message += Variant.find(params[:variant_id]).sms_share_text
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
