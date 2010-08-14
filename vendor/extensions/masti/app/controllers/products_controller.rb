class ProductsController < Spree::BaseController
  HTTP_REFERER_REGEXP = /^https?:\/\/[^\/]+\/t\/([a-z0-9\-\/]+\/)$/
  
  prepend_before_filter :reject_unknown_object, :only => [:show]
  before_filter :load_data, :only => :show
  before_filter :require_user, :only =>[:show]
  resource_controller
  helper :taxons
  actions :show, :index
  ssl_required  :show
  def index
    @products = Product.paginate(:all, :conditions => ['deleted_at is NULL'], :page => params[:page], :per_page => 10)
  end
  
  def show
#    puts "#its comming to the product show============================id:==========#{}======="
#    deal = DealHistory.find(:first, :conditions =>['is_active = ?', true])
#    @product = Product.find_by_permalink(params[:id])
    @product = Product.find(:first, :conditions => ['permalink = ? AND city_id =? ', params[:id],session[:city_id]])
    oreders = current_user.orders
    count = 0
    oreders.each do |order|
      order.line_items.each do |line_item|
        if line_item.variant.id ==  @product.variant.id
          if order.state == "paid"
            count += line_item.quantity
          end
        end
      end
    end
    if @product.max_vouchers.nil? or count < @product.max_vouchers
      session[:order_id] = nil
      redirect_to(:controller => "orders", :product => @product.id, :type => params[:type])
    else
      flash[:error] = "You have already bought the maximum allowed number of purchases in this deal.  We implement the maximum number of purchases per user to ensure that a large number of users can use this offer."
      redirect_to :back
    end
    
  end
  
  include Spree::Search
  layout 'spree_application'
  
  def change_image
    @product = Product.available.find_by_param(params[:id])
    img = Image.find(params[:image_id])
    render :partial => 'image', :locals => {:image => img}
  end
  
  private
  
  def load_data    
    #load_object     
    @variants = Variant.active.find_all_by_product_id(@product.id, 
                :include => [:option_values, :images])
    @product_properties = ProductProperty.find_all_by_product_id(@product.id, 
                          :include => [:property])
    @selected_variant = @variants.detect { |v| v.available? }
    
    referer = request.env['HTTP_REFERER']
    
    if referer  && referer.match(HTTP_REFERER_REGEXP)
      @taxon = Taxon.find_by_permalink($1)
    end
  end
  
  def collection
    retrieve_products
  end
  
  def accurate_title
    @product ? @product.name : nil
  end
  
end
