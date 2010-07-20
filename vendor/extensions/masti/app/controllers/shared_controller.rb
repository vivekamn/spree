class SharedController < ApplicationController
   def plaxo_cb
    render :layout => false
  end
  
  def sms_deal_notify
#    if !params[:name].nil? and !params[:mobile_no].nil?
      sms_notify = SmsNotify.find_by_mobile_no(params[:mobile_no])
      if sms_notify.nil?
        sms_notify = SmsNotify.new
        sms_notify.name = params[:name]
        sms_notify.mobile_no = params[:mobile_no]
        sms_notify.save
      end
      message = "Hi, Congrats! You have successfully registered with MasthiDeals.com. We will inform you about the new deals we lauch.For more details, please logon to www.masthideals.com - Lakshmi, MasthiDeals Team."
      send_sms(params[:mobile_no], message)    
#    end
    redirect_to home_url
  end
  
   def send_sms(phone_no,message)
      query = "INSERT INTO jenooutbox (mobilenumber,message) VALUES('#{ phone_no }','#{message}');"
      result = ActiveRecord::Base.connection.execute(query)
    end
  
  def plaxo_invite
    recipients = params[:recipients]
    content = params[:body] 
    name = params[:name] 
#    count=recipients.split(",").count
#    count = current_user.invited_count
    UserMailer.deliver_plaxo_invite(current_user.email,recipients,name,content)
    if current_user.is_cmom==true
      cnt= "two"
    else
      cnt= "one"
    end
    flash[:success] = "Thanks for inviting your friends to MasthiDeals.com".to_html
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
