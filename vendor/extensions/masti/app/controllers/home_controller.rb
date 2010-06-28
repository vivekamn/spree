class HomeController < Spree::BaseController
    require 'RubyRc4.rb'
    require 'base64'
    ssl_required  :index, :unique_email,:product_preview,:payment_response,:sitemap,:email_deal_notify,:voucher,:create,:create,:progress_bar,:get_featured,:terms_conditions,:about_us,:upcoming_deals,:how_masti_works,:faq,:contact_us,:other_cities
#   before_filter :require_user,:only=>[:get_featured]
    skip_filter :protect_from_forgery
    before_filter :set_city

  def set_chennai
    unless params[:city_id].nil?
      session[:city_id] = params[:city_id]
    end    
    redirect_to chennai_path
  end

  def set_bangalore
    unless params[:city_id].nil?
      session[:city_id] = params[:city_id]
    end    
    redirect_to bangalore_path
  end  

  def index
    if session[:city_id].nil?
      session[:city_id] = 1
    end   
    @deal = DealHistory.find(:first, :conditions =>['is_active = ? and city_id =?', true, session[:city_id]])  
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

  def unique_email
    count = User.count(:all, :conditions => ['email = ?',params[:email]] )
    if count > 0
      render(:text => 'false' )
    else
      render(:text => 'true')
    end
  end
  
  def share_this
    puts "#{params[:name]}-------->"
    recipients = params[:recipients]
    name = params[:recipients]
    from=params[:from]
    puts "#{params[:from]}-------->"
    current_deal = DealHistory.find(:first, :conditions => "is_active = 1")
    product = Product.find(:first, :conditions =>"id = #{current_deal.product_id}")
    split_recipients = recipients.split(",")
    split_recipients.each do |recipient|
      UserMailer.deliver_share_this(recipient,from,product,params[:name])
    end
    flash[:success]="Deal Shared to your friends"
    redirect_to home_url
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

  #getting the featured deal informations from the user
#  def create
#    @enquiry=Enquiry.new(params[:enquiry])
#    if @enquiry.save
#      flash[:success]="Thank you for request. We have customer support. They will get back you on this shortly."      
#      redirect_to home_url
#    else
#      flash[:error]="Oops You are missing Something."      
#      redirect_to get_featured_path
#    end
#  end
  
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

  def set_city
    unless params[:city_id].nil?
      session[:city_id] = params[:city_id]
    end
  end  
end
