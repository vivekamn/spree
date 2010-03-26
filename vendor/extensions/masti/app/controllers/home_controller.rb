class HomeController < Spree::BaseController
    require 'RubyRc4.rb'
    require 'base64'
#   before_filter :require_user,:only=>[:get_featured]
  def index
    @deal = DealHistory.find(:first, :conditions =>['is_active = ?', true])  
    @featured_product = Product.find(:first, :conditions => ['id = ?',@deal.product_id])
    @price = @featured_product.price.to_i
    @discount = @featured_product.discount
    @saving = (@price*@discount/100).to_i
    @bought_count = @featured_product.currently_bought_count
#    Time.zone="UTC"
#    @exp_time=Time.zone.parse(@featured_product.deal_expiry_date.to_s)
#    puts "#{Time.now}========="
#    puts "#{Time.parse(@featured_product.deal_expiry_date.to_s)}"
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
      @checkout=@order.checkout
      if @order.state=='new' # check if user is paying again for a paid order or cancelled order
    if @response_txt['ResponseMessage']=='Transaction Successful'      
      @order.pay!             
      InventoryUnit.deal_status_update(@order) if @order.email # send confirmation mails      
    else
      @order.cancel! if @order.state!='canceled'     
    end
  else
    @err_message = "Already Paid or Cancelled Order "
    end
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
      flash[:error]="You Have already Subscribed to Masthi Deal Newsletter."      
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
end
