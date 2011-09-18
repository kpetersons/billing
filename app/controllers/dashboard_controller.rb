class DashboardController < ApplicationController

  layout "dashboard"
  def show
    @recent_activity_matters = Matter.where("updated_at between ? and ?", Date.today-5, Date.today+1).paginate(:page => params[:param_name])
    @upcoming_deadlines_matters = Matter.joins(:matter_tasks).where('proposed_deadline between ? and ?', Date.today-1, Date.today + 5).paginate(:page => params[:param_name])
    @message = Message.last
  end

  def message
    @recent_activity_matters = Matter.where("updated_at between ? and ?", Date.today-5, Date.today+1).paginate(:page => params[:param_name])
    @upcoming_deadlines_matters = Matter.joins(:matter_tasks).where('proposed_deadline between ? and ?', Date.today-1, Date.today + 5).paginate(:page => params[:param_name])
    @message = get_message params[:id]
    render 'show'
  end

  private

  def get_message id
    if id.nil?
      return Message.last
    end
    return Message.find(id)
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Message not found! Showing last."
    return Message.last
  end

end
