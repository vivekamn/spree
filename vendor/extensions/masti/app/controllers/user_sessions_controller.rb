class UserSessionsController < Spree::BaseController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
   ssl_required :new, :create, :destroy, :update
  ssl_allowed :login_bar
    def xd_receiver
    render :layout => false
  end
  def new
    @user_session = UserSession.new
  end
  
  def create_by_facebook_id  
    facebook_id=params[:fb_id_hidden]
    @current_user = already_connected?(facebook_id)  
    if @current_user           
      session[:fb_logged] = "true" 
      create_user_session(@current_user)
   else
      session[:needs_fb_linking]="true"
      redirect_to :controller=>'user_sessions', :action=>'new'
    end
  end
  
  def already_connected?(facebook_id)
    User.find_by_fb_user_id(facebook_id)    
  end
  
  def create    
    not_need_user_auto_creation = 
        user_without_openid(params[:user_session]) ||
        user_with_openid_exists?(:openid_identifier => params['openid.identity']) ||
        user_with_openid_exists?(params[:user_session]) 

    if not_need_user_auto_creation
      create_user_session(params[:user_session], params[:fb_id_hid])   
    else
      create_user(params[:user_session])
    end
    
    if @user_session.record
      order = @user_session.record.orders.last(:conditions => {:completed_at => nil})
      if order
        session[:order_token] = order.token
        session[:order_id] = order.id
      end
    end
  end

  def destroy
    session[:fb_logged]=nil unless session[:fb_logged].nil?
    session[:needs_fb_linking]=nil unless session[:needs_fb_linking].nil?
    current_user_session.destroy
    session.clear
    unless session[:src].nil?
      session[:src].clear
    end
    
    flash[:notice] = t("logged_out")
    redirect_to home_url
  end
  
  def nav_bar
    render :partial => "shared/nav_bar"
  end
  
  private
  
  def user_with_openid_exists?(data)
    data && !data[:openid_identifier].blank? &&
      !!User.find(:first, :conditions => ["openid_identifier LIKE ?", "%#{data[:openid_identifier]}%"])
  end
  
  def user_without_openid(data)
    data && data[:openid_identifier].blank?
  end
  
  def create_user_session(data, fb_id_hid=nil)
    @user_session = UserSession.new(data)
    @user_session.save do |result|
      if result        
        session[:logged_in_from_affiliate] = session[:affiliate]
        respond_to do |format|
          format.html {
            if data[:remember_me] == "1"
               cookies[:email]=data[:login]
            end
            flash[:notice] = t("logged_in_succesfully") unless session[:return_to]
            unless session[:needs_fb_linking].nil?
            unless fb_id_hid.nil?             
             user = @user_session.record if @user_session.record
            user.fb_user_id = fb_id_hid
            user.save!
            session[:fb_logged] = "true" unless @user_session.record.fb_user_id.nil?
          end
          end
          session[:needs_fb_linking]=nil
                        
            redirect_back_or_default home_url
          }
          format.js {
            user = @user_session.record
            render :json => {:ship_address => user.ship_address, :bill_address => user.bill_address}.to_json
          }
        end
      else
        respond_to do |format|
          format.html {
            flash.now[:error] = t("login_failed")+' <a href="password_resets/new"> Forgot Password?</a>'.to_html
            render :action => :new
          }
          format.js { render :json => false }
        end
      end
    end
    redirect_back_or_default(home_url) unless performed?
  end
  
  def create_user(data)
    @user = User.new(data)

    @user.save do |result|
      if result
        flash[:notice] = t(:user_created_successfully) unless session[:return_to]
        redirect_back_or_default home_url
      else
        flash[:notice] = t(:missing_required_information)
        redirect_to :controller => :users, :action => :new, :user => {:openid_identifier => @user.openid_identifier}
      end
    end
  end

  def accurate_title
    I18n.t(:log_in)
  end
  
end
