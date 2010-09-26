class FacebookController < Spree::BaseController
  skip_before_filter :ensure_application_is_installed_by_facebook_user, :ensure_has_status_update, :ensure_has_photo_upload, :ensure_has_video_upload, :ensure_has_create_listing, :ensure_has_create_event, :ensure_authenticated_to_facebook
  layout 'facebook'
  
  def fb_game
    params[:fb_user_id] = 100000362520920
    active_deal = DealHistory.find(:first, :conditions => ['is_active = ? AND city_id =?', true, session[:city_id]])
    product = Product.find(active_deal.product_id)
    @question = product.active_poll_question
    user_answer = ActivePollUserAnswer.find(:all,:conditions=>["fb_user_id = ? and active_poll_question_id = ?",params[:fb_user_id],@question.id])
    if !user_answer.nil? and !user_answer.empty?
      redirect_to error_page_path
    end
    @options = @question.active_poll_answers
  end
  
  def check_if_lucky
    user_answer = ActivePollUserAnswer.find(:all,:conditions=>["fb_user_id = ? and active_poll_question_id = ?",params[:fb_user_id],params[:qusetion_id]])
    if user_answer.nil? or user_answer.empty?
      user_answer = ActivePollUserAnswer.new(:active_poll_question_id=>params[:qusetion_id],:active_poll_answer_id=>params[:answer][:user_answer],:fb_user_id=>params[:fb_user_id])
      question = ActivePollQuestion.find(params[:qusetion_id])
      luck_no = [6,15,24,33,42,3,5,8,27,30]
      user_no = rand(50)
      logger.info "#{user_no}"
      user_no = 27
      got_price = luck_no.include?(user_no)
      user = User.find_by_fb_user_id(params[:fb_user_id])
      price_got_count = ActivePollUserAnswer.count(:all,:conditions=>["price_no = ? and active_poll_question_id = ?",user_no,params[:qusetion_id]])
      if got_price and (price_got_count.nil? or price_got_count<1)
        user_answer.price_no = user_no
        user_answer.save!
        if !user.nil?
          dir_credit_md_money(user,question.product)
        else
          redirect_to "/facebook/tip?user_answer=#{user_answer.id}"
        end
      else
        user_answer.save!
        redirect_to "/facebook/tip?user_answer=#{user_answer.id}"
      end
    else
      redirect_to facebook_error_page_path
    end
  end
  
  def dir_credit_md_money(user,product)
    user_promotion = UserPromotion.find(:first,:conditions=>['user_id = ? ',user.id])   
    promotion_obj = UserPromotion.find_by_user_id(user.id)
    if user_promotion.nil?
      UserPromotion.create(:credit_amount => 50, :user_id => user.id)
    else
      user_promotion.credit_amount = 0 if user_promotion.credit_amount.nil?
      user_promotion.update_attributes(:credit_amount => user_promotion.credit_amount+50)            
    end
    redirect_to md_money_success_path
  end
  
  
  def tip
    unless params[:user_answer].nil?
      @user_answer = ActivePollUserAnswer.find(params[:user_answer])
      @question = ActivePollQuestion.find(@user_answer.active_poll_question_id)
    end
  end
  
  def update_md_money
    user = User.find(:first,:conditions=>['email = ? or phone_no= ?',params[:user][:email],params[:user][:mobile_no]])
    question = ActivePollQuestion.find(params[:question_id])
    user_qa =  ActivePollUserAnswer.find(params[:answer_id])
    if user.nil?
      user = User.new(:email=>params[:user][:email].strip.downcase,:password=>"Test1234",:password_confirmation=>"Test1234",:phone_no=>params[:user][:mobile_no],:city_id=>session[:city_id])
      user.save!
      #      UserMailer.deliver_success_sms_registration(user,question.product)
      #      message="Thanks for registering with MasthiDeals.com. Your username/ pwd is emailed to you. You have earned 50 Rs which you can use to buy any deal in Masthideals..com"
      #      send_sms(params[:mobile_no], message,100)
    end
    if !user_qa.price_no.nil?
      credit_md_money(user,question.product)
    else
      credit_points(user,10)
    end
  end
  
  def credit_points(user,points)
    unless user.nil?
      user_promotion = UserPromotion.find(:first,:conditions=>['user_id = ?',user.id])
      if user_promotion.nil?
        user_promotion = UserPromotion.create(:points => points, :user_id => user.id)
      else
        user_promotion.update_attributes(:points => user_promotion.points+points)            
      end
    end
    redirect_to md_money_success_path(:from=>"points",:promotion_id=>user_promotion.id)
  end
  
  def credit_md_money(user,product,email=nil)
    user_promotion = UserPromotion.find(:first,:conditions=>['user_id = ? or email= ? ',user.id,email])   
    promotion_obj = UserPromotion.find_by_user_id(user.id)
    if user_promotion.nil?
      UserPromotion.create(:credit_amount => 50, :user_id => user.id)
    else
      user_promotion.credit_amount = 0 if user_promotion.credit_amount.nil?
      actual_mul_points = (user_promotion.points/50).to_i == 0 ? 1 : (user_promotion.points/50).to_i
      user_promotion.update_attributes(:credit_amount => user_promotion.credit_amount+(50 * actual_mul_points),:points=> user_promotion.points>=50 ? user_promotion.points-(50 * actual_mul_points) : 0,:user_id=>user.id)            
    end
    redirect_to md_money_success_path
  end
  
  def get_email
    if !cookies[:email].nil? and params[:error].nil?
      redirect_to fb_game_path
    end
  end
  
  def md_money_success
#   unless params[:promotion_id].nil?
#     @user_promotion = UserPromotion.find(params[:promotion_id])
#     @user = UserPromotion.user
#   end
  end
  
  
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
