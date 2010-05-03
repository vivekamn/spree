class UsersController < Spree::BaseController
  resource_controller
  
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]

  ssl_required :new, :create, :edit, :update, :show
  
  actions :all, :except => [:index, :destroy]
	
	#Cannot use resource_controller for create action
	#as openID expects block passed to user.save method
	def create
	  @user = User.new(params[:user])    
	  @user.save do |result|
	    if result       
	      flash[:notice] = t(:user_created_successfully) unless session[:return_to]
	       current_deal = DealHistory.find(:first, :conditions => "is_active = 1")
         product = Product.find(:first, :conditions =>"id = #{current_deal.product_id}")
        UserMailer.deliver_registration(@user,product)
        @user.roles << Role.find_by_name("admin") unless admin_created?
        respond_to do |format|
	        format.html { redirect_back_or_default home_url }
	        format.js { render :js => true.to_json }
	      end
	    else            
	      respond_to do |format|
	        format.html { render :action => :new }
	        format.js { render :js => @user.errors.to_json }
	      end
	    end
	  end
	end

  show.before :show_before
  new_action.before :new_action_before

  def update
    #load_object
   @user = current_user if current_user     
    begin  
      unless @user.bill_address.empty? or  @user.bill_address.nil?
        bill_address=@user.bill_address
       if  @user.update_attributes(params[:user]) and bill_address.update_attributes!(params[:user][:bill_address_attributes])  
         puts "coming here==========="
          flash[:success] = t("account_updated")
          flash[:error] = nil
          render :action => :edit  
        else
          #flash[:error] = bill_address.errors.to_s
          render :action => :edit  
        end
      else
        bill_address=Address.new
        bill_address.name = params[:user][:bill_address_attributes][:name]
        bill_address.address1 = params[:user][:bill_address_attributes][:address1]
        bill_address.city = params[:user][:bill_address_attributes][:city]
        bill_address.zipcode = params[:user][:bill_address_attributes][:zipcode]
        bill_address.country_id = 41
        bill_address.phone = params[:user][:bill_address_attributes][:phone]
        bill_address.state_id = params[:user][:bill_address_attributes][:state_id]
        bill_address.save!
        @user.bill_address = bill_address
        puts "#{@user.bill_address.id}------------------"
        if  @user.update_attributes(params[:user]) and @user.bill_address.update_attributes!(params[:user][:bill_address_attributes])    
          puts "#{@user.bill_address.id}------------------"
          flash[:success] = t("account_updated")
          flash[:error] = nil
          render :action => :edit  
        else
          #flash[:error] = bill_address.errors.to_s
          render :action => :edit  
        end
      end
      
      
    rescue Exception=>e      
      logger.info "unable to update user................"+e.message      
      flash[:error] = e.message 
      flash[:success] = nil
      render :action => :edit
    end
  end
  
#  def edit
#    @user||=current_user
#    @user.bill_address ||= Address.default    
#  end

  private

    def object      
      @object ||= current_user      
      @object.bill_address ||= Address.default
      @object
    end
    
    def show_before
      @orders = @user.orders.payment_success
    end
    
    def new_action_before
      flash.now[:notice] = I18n.t(:please_create_user) unless admin_created?
    end

    def accurate_title
      I18n.t(:account)
    end
end
