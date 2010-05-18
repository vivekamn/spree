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
    session[:order_id] = nil
    redirect_to(:controller => "orders", :product => @product.id, :type => params[:type])
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
