class SharedController < ApplicationController
   def plaxo_cb
    render :layout => false
  end
  
  def plaxo_invite
    recipients = params[:recipients]
    content = params[:body] 
    name = params[:name] 
    count=recipients.split(",").count
    UserMailer.deliver_plaxo_invite(current_user.email,recipients,name,content)
    flash[:success] = "Thanks for inviting your friends to MasthiDeals.com. Since YOU invited them, we are gifting 50 MasthiDeals Money to your friends. If five of your friend register then you get two satyam cinema tickets free. Do you want to  <a href='/invite-your-friends'>invite more of your friends?</a>".to_html
    redirect_to home_url
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
