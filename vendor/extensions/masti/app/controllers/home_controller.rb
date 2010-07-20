class HomeController < Spree::BaseController
  require 'RubyRc4.rb'
  require 'base64'
  ssl_required  :index,:unique_email,:product_preview,:payment_response,:sitemap,:email_deal_notify,:voucher,:create,:create,:progress_bar,:get_featured,:terms_conditions,:about_us,:upcoming_deals,:how_masti_works,:faq,:contact_us,:other_cities
  before_filter :require_user,:only=>[:verify_mobile]
  before_filter :req_user_invite,:only=>:invite_friends
  before_filter :fls_fr_okt_fb_user, :only => [:index,:how_masti_works,:get_featured,:upcoming_deals,:recent_deals]
  skip_filter :protect_from_forgery
  #    before_filter :update_user_credit,:only=>[:from_cmom_check]
  def index
    if params[:side_deal_info].nil?
      @deal_param = 'side_deal'
      @deal = DealHistory.find(:first, :conditions =>['is_active = ?', true])
      @side_deal = DealHistory.find(:first, :conditions => ['is_side_deal = ?', true])
    else
      if params[:side_deal_info] == 'side_deal'
        @deal_param = 'main_deal'
        @deal = DealHistory.find(:first, :conditions => ['is_side_deal = ?', true])
        @side_deal = DealHistory.find(:first, :conditions =>['is_active = ?', true])
      else
        @deal_param = 'side_deal'
        @deal = DealHistory.find(:first, :conditions =>['is_active = ?', true])
        @side_deal = DealHistory.find(:first, :conditions => ['is_side_deal = ?', true])
      end
    end
    @featured_product = Product.find(:first, :conditions => ['id = ?',@deal.product_id])
    @price = @featured_product.price.to_i
    @discount = @featured_product.discount
    @saving = (@price*@discount/100).to_i
    @bought_count = @featured_product.currently_bought_count
    unless params[:email].nil? and params[:product_id].nil?
      email_trace = EmailTrace.find(:first,:conditions=>['email = ? and product_id = ?',params[:email],params[:product_id]])
      if email_trace.nil?
        email_trace = EmailTrace.new 
        email_trace.email = params[:email]
        email_trace.product_id = params[:product_id]
        email_trace.save!
      end
    end
  end
  
  def fls_fr_okt_fb_user
    unless current_user
      unless session[:src].nil?
        flash[:invite] = "<span class='green' style='margin-left:0px;font-size:18px;font-weight:bold;'>You can earn 100 Rs  by registering with MasthiDeals.com ( Its easy and free! )</span>. <span class='blue' style='font-size:18px;font-weight:bold;'>You can use this money to buy any deal in MasthiDeals.com. <a href='/signup'><u>Please go ahead and register</u></a></span>.".to_html
      end      
    end
  end
  
  def order_vendor
    unless params[:id].nil?
      begin 
        @variant = Variant.find(:first,:include => {:product => {}},:conditions=>['id = ?',params[:id]])
        @orders = Order.find(:all,:include => {:line_items=>{},:user => {},:checkout => {}, :bill_address=>{}},:joins =>["INNER JOIN line_items ON orders.id = line_items.order_id INNER JOIN variants ON variants.id = line_items.variant_id"],:conditions=>["variants.id = ? and orders.state = 'paid'",params[:id]])
      rescue
        flash[:error] = 'Cannot find the product.Please check the product id Correctly'  
      end
    end
  end
  
  def insert_email_notify
    if (params[:email].match(/^([a-z0-9._%+-]+)@((?:[-a-z0-9]+\.)+(?:[A-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)$)$/i))
      @deals_notify = DealsNotification.find_by_email(params[:email])
      if @deals_notify.nil?
        @deals_notify = DealsNotification.new
        @deals_notify.email = params[:email] 
        unless session[:src].nil?
          @deals_notify.source = session[:src]
        end
        if @deals_notify.save
          render(:text => "Thanks for registering with MasthiDeals hot deals update. You will recieve email alerts on new deals posted in MasthiDeals.com")      
        else
          render(:text => 'false' )
        end
      else
        #if the user have already subscribed means it will show error
        render(:text => 'You have already subscribed to MasthiDeals Newsletter.' ) 
      end
    else
      render(:text => 'false')
    end 
  end
  
  def unique_email
    count = User.count(:all, :conditions => ['email = ?',params[:email]] )
    if count > 0
      render(:text => 'false' )
    else
      render(:text => 'true')
    end
  end
  
  def unique_phone
    count = User.count(:all, :conditions => ['phone_no = ?',params[:phone]] )
    if count > 0
      render(:text => 'false')
    else
      render(:text => 'true')
    end
  end
  
  def verify_mobile
    if current_user.mobile_verify==true
      flash[:error]='Your mobile number has already been verified'
      redirect_to home_url
    else
      verification_code = VerificationCode.find(:first, :conditions => ["user_id = ? and verify_type= ?", current_user.id,"Mobile"])
      if verification_code.code == params[:code]
        if !current_user.source.nil? and !current_user.source.empty?
          create_user_promotion current_user
          redirect_to invite_friends_path(:from=>"reg_complete")  
        else
          update_referer_promotion
          user = User.find_by_email(current_user.refered_by)
          unless user.nil?
            count= user.invited_count
            UserMailer.deliver_success_invite(user.email,count,current_user.email,current_user)
            
          end
          redirect_to invite_friends_path(:from=>"reg_complete_md_ref") 
        end
      else
        unless params[:md_user_ref].nil?
          flash[:error]="Please Enter Correct code.If you want to send the code again Please <a href='/generate-code?from=resend'>Click here</a>"
          redirect_to verifiy_your_phone_path(:md_user=>'true')
        else
          flash[:error]="Please Enter Correct code.If you want to send the code again Please <a href='/generate-code'>Click here</a>"
          redirect_to verifiy_your_phone_path()
        end
      end
    end
  end
  
  def cmom
    unless params[:ref].nil?
      session[:ref]=params[:ref]
    end
  end
  
  def from_cmom_check
    #    user = User.find_by_email(params[:user_email])
    #    referer = User.find_by_email(params[:referer_email])
    #    if user and referer
    #      current_user.is_cmom=true
    #      current_user.save!
    #      if params[:phone_verify]=="true"
    #        create_user_promotion user
    #        #        update_user_promotion referer
    #        redirect_to invite_friends_path(:from=>"reg_complete")
    #      else
    #        generate_code
    #      end
    #    elsif user
    #      current_user.is_cmom=true
    #      current_user.save!
    #      if params[:phone_verify]=="true"
    #        create_user_promotion user
    #        redirect_to invite_friends_path(:from=>"reg_complete")
    #      else
    #        generate_code
    #      end
    #    elsif referer
    #      generate_code('true')
    #    else
    unless current_user.source.nil? or current_user.source.empty?
      generate_code        
    else
      unless current_user.refered_by.nil? or current_user.refered_by.empty?
        user = User.find_by_email(current_user.refered_by)
        unless user.nil?
          generate_code('true')
        else
          redirect_to reg_complete_path
        end
        
      else
        redirect_to reg_complete_path
      end
    end
    #    end      
  end
  
  def verifiy_your_phone
    if current_user.mobile_verify==true
      flash[:error]='Your mobile number has already been verified'
      redirect_to home_url
    end
  end
  
  def generate_code(md_user=nil)
    if !params[:from].nil?
      md_user = 'true'
    end
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
    message = "Hi,Your Verification code is #{random} - MasthiDeals team."
    send_sms(current_user.phone_no,message)
    if md_user=='true'
      redirect_to verifiy_your_phone_path(:md_user=>'true')
    else
      redirect_to verifiy_your_phone_path  
    end
    
    
  end
  
  def invite_friends
  end
  
  def share_this
    recipients = params[:recipients]
    name = params[:recipients]
    from=params[:from]
    product_id = params[:product_id]
    #    current_deal = DealHistory.find(:first, :conditions => "is_active = 1")
    product = Product.find(:first, :conditions =>['id = ?',product_id])
    split_recipients = recipients.split(",")
    split_recipients.each do |recipient|
      UserMailer.deliver_share_this(recipient,from,product,params[:name])
    end
    flash[:success]="Deal Shared to your friends"
    redirect_to :back 
  end
  
  def check_email
    recipients = params[:email]
    @trimmed_line = recipients.delete(' ').lstrip
    @split_recipients = @trimmed_line.split(",");
    count = 0
    @split_recipients.each do |s|        
      if(s.match(/^([a-z0-9._%+-]+)@((?:[-a-z0-9]+\.)+(?:[A-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)$)$/i))
        count+= 1;
      end
    end
    if(@split_recipients.size == count)        
      render(:text => "valid")
    else
      render(:text => "Invalid")
    end
  end
  
  def product_preview
    @featured_product = Product.find_by_permalink(params[:id])
    @price = @featured_product.price.to_i
    @discount = @featured_product.discount
    @saving = (@price*@discount/100).to_i
    @bought_count = @featured_product.currently_bought_count   
  end
  
  def payment_response
    @key = '5fa2c2ffb54022d1b4e849668119e7b5'
    @DR = params[:DR]
    @response_txt={}
    @response_text =[]
    unless @DR.nil?
      @DR.gsub!(/ /,'+') 
      @encrypted_data = Base64.decode64(@DR)
      @decryptor = RubyRc4.new(@key)
      @plain_text = @decryptor.encrypt(@encrypted_data)
      @plain_text.split(/&/).each_with_index do |item, i|
        key, val = item.split(/=/)
        @response_txt[key]=val
        @response_text << "#{key}=#{val}"
      end
    end
    @order=Order.find_by_number(@response_txt['MerchantRefNo']) # the merchant ref no is the order no for which payment occurred
    begin
      @order.update_payment_info(@response_txt)
      unless @order.user.user_promotion.nil?
        @order.update_user_promotion
      end
      if @order.state=='new' # check if user is paying again for a paid order or cancelled order
        if @response_txt['ResponseMessage']=='Transaction Successful'
          @status=@order.update_payment
          if @status!='out_of_stock' and @status!='sold_out'
            logger.info "about to accept the payment..........."
            @order.pay!  # accept the payment    
            logger.info "order updated as paid after successful payment response received.........."
            InventoryUnit.deal_status_update(@order) if @order.email # send confirmation mails 
            logger.info "confirmation mails sent...................." 
          else          
            @order.update_attribute(:state, 'credit_owed') 
            # mark as over paid so that it can be reimbursed to users
            logger.info "order under count after payment success and marked as over paid"
            if @status=="out_of_stock"
              logger.info "retrieving out of stock items.............."
              flash[:error] = 'Following out of stock'
              flash[:error] += '<ul>'
              @order.out_of_stock_items.each do |item|
                flash[:error] += '<li>' + t(:count_of_reduced_by,
                              :name => item[:line_item].variant.name,
                              :count => item[:count]) +
                          '</li>'
              end
              flash[:error] += '<ul>'
            end   
            InventoryUnit.deal_status_update(@order) if @order.email
          end
        else
          @order.cancel! if @order.state!='canceled'   # just mark the order as cancel as payment failed
          logger.info "payment failed and order cancelled"  
        end
      else
        @err_message = "Already Paid or Cancelled Order "
      end
    rescue Exception=>e
      logger.info e.message
      #flash[:error]=e.message
      redirect_to :action=>'payment_failure'
    end
  end
  
  def sitemap
    
  end
  
  #to get the email id from the user and store it in the deal notifications table
  
  def email_deal_notify
    @deals_notify = DealsNotification.find_by_email(params[:deals_notification][:email])
    if @deals_notify.nil?
      @deals_notify = DealsNotification.new(params[:deals_notification])
      unless session[:src].nil?
        @deals_notify.source = session[:src]
      end
      if @deals_notify.save
        flash[:success]="Thanks for registering with MasthiDeals hot deals update. You will recieve email alerts on new deals posted in MasthiDeals.com"      
      else
        flash[:error]="E-mail subscription Failed."
      end
    else
      #if the user have already subscribed means it will show error
      flash[:error]="You have already subscribed to MasthiDeals Newsletter. Would you like to register another email id?"      
    end
    redirect_to :back
  end
  
  def voucher
    @order=Order.find(params[:id])
    line_items_coll=@order.line_items
    line_items_coll.each do |item|
      @item=item
      @product=item.variant.product
    end
  end
  
  def create
    @enquiry=Enquiry.new(params[:enquiry])
    begin
      @enquiry.save!
      flash[:success]="Thank you for request. We have customer support. They will get back you on this shortly."      
      redirect_to home_url    
    rescue Exception=>e
      flash[:error]=e.message      
      redirect_to :back
    end
  end
  
  def progress_bar
    current_deal = Product.find(:first, :conditions => ['id = ?',params[:id]])
    variant=current_deal.master
    if variant.count_on_hand==0
      bought_percent = 300
    else
      bought_percent = (current_deal.currently_bought_count*300)/(current_deal.currently_bought_count+variant.count_on_hand)
    end
    render(:text =>bought_percent)
  end
  
  def terms_conditions
    
  end
  
  def about_us
    
  end
  
  def recent_deals
    @bar_selected="recent_deals"
  end
  
  def upcoming_deals
    @bar_selected="upcoming_deals"
  end
  
  def how_masti_works
    @bar_selected="how_masthi_works"
  end
  
  def faq
  end
  
  def contact_us
  end
  
  def get_featured
    @bar_selected="get_featured"
  end 
  
  def other_cities
    
  end 
  
  def update_assets
    # copy the assets from extensions public dir into #{RAILS_ROOT}/public
    destination = "#{RAILS_ROOT}/public"
    paths_to_mirror = Spree::ExtensionLoader.instance.load_extension_roots
    @update_ok = true
    paths_to_mirror.each do |extension_path|
      source = "#{extension_path}/public"
      if File.directory?(source)
        begin
          RAILS_DEFAULT_LOGGER.info "INFO: Mirroring assets from #{source} to #{destination}"
          Spree::FileUtilz.mirror_files(source, destination)
        rescue LoadError, NameError => e
          $stderr.puts "Could not copy extension assets from : #{source}.\n#{e.inspect}"
          @update_ok = false
          nil
        end
      end
    end 
  end
  
  private
  
  def req_user_invite
     if cookies[:email].nil? and params[:email].nil? 
       unless current_user
        store_location
        flash[:notice] = I18n.t("page_only_viewable_when_logged_in")
        redirect_to new_user_session_url
        return false
      end
    elsif !cookies[:email].nil?
      return true
    else
     user= User.count(:conditions=>['email = ?',params[:email]]) 
      if user>0
       cookies[:email]=params[:email]
      else
         unless current_user
          store_location
          flash[:notice] = I18n.t("page_only_viewable_when_logged_in")
          redirect_to new_user_session_url
          return false
        end
      end
    end
  end
  
  
  def send_sms(phone_no,message,priority)
    query = "INSERT INTO jenooutbox (mobilenumber,message,priority) VALUES('#{ phone_no }','#{message}',#{priority});"
    result = ActiveRecord::Base.connection.execute(query)
  end
  
  def create_user_promotion user
    UserPromotion.create(:credit_amount => 100, :user_id => user.id)
    current_user.mobile_verify=true
    current_user.save!
    user=User.find_by_email(current_user.refered_by)
    unless user.nil?
      user.invited_count +=1
      user.save!
    end
  end
  
  def update_referer_promotion
    referer_promotion = UserPromotion.find_by_user_id(current_user.id)    
    if referer_promotion.nil?
      UserPromotion.create(:credit_amount => 50, :user_id => current_user.id)
    else
      referer_promotion.credit_amount += 50
      referer_promotion.save
    end
    current_user.mobile_verify=true
    current_user.save!
    user=User.find_by_email(current_user.refered_by)
    unless user.nil?
      user.invited_count +=1
      user.save!
    end
  end
  
end