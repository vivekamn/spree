class SharedController < ApplicationController
   def plaxo_cb
    render :layout => false
  end
  
  def plaxo_invite
    recipients = params[:recipients]
    content = params[:body] 
    name = params[:name] 
    count=recipients.split(",").count
    UserMailer.deliver_plaxo_invite(current_person.email,recipients,name)
    flash[:success] = "Thanks for inviting your friends to MasthiDeals.com. Since YOU invited them, we are gifting 50 MasthiDeals Money to your friends. If five of your friend register then you get two satyam cinema tickets free. Do you want to  <a heref='/home/invite_friends/1'>invite more of your friends?</a>"
    redirect_to home_url
  end
  
  def after_invite
    
  end
  
  def verifiy_your_phone
    verification_code = VerificationCode.find(:first, :conditions => ["user_id = ? and verify_type= ?", current_user.id,"Mobile"])
    verification_code = VerificationCode.new if verification_code.nil?
    verification_code.user = current_user
    record = true
    while record
      random = "#{Array.new(5){rand(5)}}"
      record = VerificationCode.find(:first, :conditions => ["code = ?", random])
    end
    verification_code.code = random
    verification_code.verify_type="Mobile"
    verification_code.save!
    message = "Hi,Your Verication code is #{random} - MasthiDeals team."
    DealHistory.send_sms(current_user.phone_no,message)
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
