class Admin::VendorsController < Admin::BaseController
   resource_controller

  index.response do |wants|
    wants.html { render :action => :index }
    wants.json { render :json => @collection.to_json}
  end
  
  
  new_action.response do |wants|
    wants.html {render :action => :new, :layout => false}
  end



  create.response do |wants|
    # go to edit form after creating as new product
    wants.html {redirect_to :controller=>'admin/vendors', :action=>'index' }
  end

  update.response do |wants|
    # override the default redirect behavior of r_c
    # need to reload Product in case name / permalink has changed
    wants.html {redirect_to :controller=>'admin/vendors', :action=>'index' }
  end

   # override the destory method to set deleted_at value
   # instead of actually deleting the product.
  def destroy
    @vendor = Vendor.find(params[:id])
    @vendor.deleted_at = Time.now()

    if @vendor.save
      flash[:notice] = "Vendor has been deleted"
    else
      flash[:notice] = "Vendor could not be deleted"
    end

    respond_to do |format|
      format.html { redirect_to collection_url }
      format.js  { render_js_for_destroy }
    end
  end
#
#  def clone
#    load_object
#    @new = @product.duplicate
#
#    if @new.save
#      flash[:notice] = "Product has been cloned"
#    else
#      flash[:notice] = "Product could not be cloned"
#    end
#
#    redirect_to edit_admin_product_url(@new)
#  end
#
  private

  def collection
    @search = Vendor.searchlogic(params[:search])
    @search.order ||= "descend_by_created_at"
    @search.deleted_at_null = true
    # QUERY - get per_page from form ever???  maybe push into model
    # @search.per_page ||= Spree::Config[:orders_per_page]

    # turn on show-complete filter by default
#    unless params[:search] && params[:search][:completed_at_not_null]
#      @search.completed_at_not_null = true
#    end

    @collection = @search.paginate(:per_page => Spree::Config[:orders_per_page],
                                   :page     => params[:page])
  end
end
  