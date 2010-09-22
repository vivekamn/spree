class Admin::ActivePollQuestionsController < Admin::BaseController
  resource_controller
  belongs_to :product
  
  new_action.response do |wants|
    wants.html {render :action => :new, :layout => false}
  end

  create.before :create_before
  
  # redirect to index (instead of r_c default of show view)
#  create.response do |wants| 
#    wants.html {redirect_to collection_url}
#  end
  def edit
#    @active_poll_question = ActivePollQuestion.find(@product.find)
  end
  
  def create
    @active_poll_question = ActivePollQuestion.new(params[:active_poll_question])
    @active_poll_question.city_id = session[:city_id]
    @active_poll_question.product_id=params[:product_code]
    @active_poll_question.posted_date = Time.now
    previous_poll_id = ActivePollQuestion.find_previous_poll_id
    @active_poll_question.name = "active_poll_#{previous_poll_id+1}"
    @active_poll_question.save
    flash[:notice]="Successfully added the Game Question"
    redirect_to collection_url 
  end
  # redirect to index (instead of r_c default of show view)
  update.response do |wants| 
    wants.html {redirect_to collection_url}
  end
  
  # override the destory method to set deleted_at value 
  # instead of actually deleting the product.
  def destroy
    question = ActivePollQuestion.find(params[:id])
    question.active_poll_answers.each do |answer|
      answer.destroy
    end
    question.destroy
    flash[:notice] = "Game Deleted Successfully..."     
    respond_to do |format|
      format.html { redirect_to collection_url }
      format.js  { render_js_for_destroy }
    end
  end

  def create_before 
    
#    option_values = params[:new_variant]
#    option_values.each_value {|id| @object.option_values << OptionValue.find(id)}
#    @object.save
  end
  
  def collection
     @active_poll_question = ActivePollQuestion.new
     @active_poll_question.active_poll_answers.build
#    @deleted =  (params.key?(:deleted)  && params[:deleted] == "on") ? "checked" : ""
#    
#    if @deleted.blank?
#      @collection ||= end_of_association_chain.active.find(:all)
#    else
#      @collection ||= end_of_association_chain.deleted.find(:all)
#    end
  end
 
end
