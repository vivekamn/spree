class FacebookController < Spree::BaseController
  skip_before_filter :ensure_application_is_installed_by_facebook_user, :ensure_has_status_update, :ensure_has_photo_upload, :ensure_has_video_upload, :ensure_has_create_listing, :ensure_has_create_event, :ensure_authenticated_to_facebook
  layout 'facebook'
  
  def fb_game
    if current_user
      cookies[:email] = current_user.email
    end    
    if !cookies[:email].nil?
      if !cookies[:email].strip.match(/^([a-z0-9._%+-]+)@((?:[-a-z0-9]+\.)+(?:[A-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)$)$/i)
         redirect_to get_email_path(:error=>"Invalid email")       
      end
      active_deal = DealHistory.find(:first, :conditions => ['is_active = ? AND city_id =?', true, session[:city_id]])
      product = Product.find(active_deal.product_id)
      @question = product.active_poll_question
      user_answer = ActivePollUserAnswer.find(:all,:conditions=>["email = ? and active_poll_question_id = ?",cookies[:email],@question.id])
      if !user_answer.nil? and !user_answer.empty?
        if params[:like_paid] == "true"
          flash[:error] = "You have already Answered....But 50MD money credited for liking our facebook page....."
        else
          flash[:error] = "You have already Answered......."
        end        
        redirect_to error_page
      end
      @options = @question.active_poll_answers
    else
      redirect_to get_email_path
    end
  end
  
 def get_email
   if !cookies[:email].nil? and params[:error].nil?
     redirect_to fb_game_path
   end
 end
  
  def 
  
  
  def error_page
    
  end
  
  def create_remote_user
    like_paid = false   
   email = params[:email_remote]
   mobile = params[:mobile_remote]
   facebook_id=params[:fb_id_hidden_remote]
   user = User.find_by_email(email)
   unless user.nil?
     user_promotion = user.user_promotion
     unless user_promotion.nil?
       if user_promotion.fb_like_paid == false
       user_promotion.update_attributes(:credit_amount => user_promotion.credit_amount+50, :fb_like_paid => true)
       like_paid = true
       end
     else
       user.user_promotion = UserPromotion.new(:credit_amount => 50, :fb_like_paid => true)
       like_paid = true
       user.save
     end     
 else
   user = User.new(:email=>email,:password=>"Test1234",:password_confirmation=>"Test1234",:phone_no=>mobile,:city_id=>session[:city_id])
   user.user_promotion = UserPromotion.new(:credit_amount => 50, :fb_like_paid => true)
   like_paid = true
   user.save   
   end
   redirect_to fb_game_path(:like_paid => like_paid)
  end
end
