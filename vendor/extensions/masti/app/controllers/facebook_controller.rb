class FacebookController < Spree::BaseController
  skip_before_filter :ensure_application_is_installed_by_facebook_user, :ensure_has_status_update, :ensure_has_photo_upload, :ensure_has_video_upload, :ensure_has_create_listing, :ensure_has_create_event, :ensure_authenticated_to_facebook
  layout false;
  
  
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
