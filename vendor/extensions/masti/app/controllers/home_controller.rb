class HomeController < Spree::BaseController

#   before_filter :require_user,:only=>[:get_featured]
  def index
    deal = DealHistory.find(:first, :conditions =>['is_active = ?', true])  
    @featured_product = Product.find(:first, :conditions => ['id = ?',deal.product_id])
  end
  
  
  #to get the email id from the user and store it in the deal notifications table
  def email_deal_notify
      @deals_notify = DealsNotification.find_by_email(params[:deals_notification][:email])
      if @deals_notify.nil?
        @deals_notify = DealsNotification.new(params[:deals_notification])
        if @deals_notify.save
          flash[:success]="Thank you for registering to Masthi Deal Newsletter."      
        else
          flash[:error]="E-mail subscription Failed."
        end
    else
      #if the user have already subscribed means it will show error
      flash[:error]="You Have already Subscribed to Masthi Deal Newsletter."      
    end
    redirect_to :back
  end
  
  
  #getting the featured deal informations from the user
  def create
    @enquiry=Enquiry.new(params[:enquiry])
    if @enquiry.save
      flash[:success]="Scheduled your MasthiDeal Successfully."      
      redirect_to home_url
    else
      flash[:error]="Oops You are missing Something."      
      redirect_to get_featured_path
    end

  end
  
  def about_us
  end
  
  def how_masti_works
  end
  
  def faq
  end
  
  def contact_us
  end
  
  def get_featured
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
