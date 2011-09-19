class DashboardController < ApplicationController

  layout "dashboard"

  before_filter :show_column_filter, :only => [:show, :message]

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

  def reset
    UserFilterColumn.transaction do
      UserFilter.reset_filter current_user, 'matters_deadlines'
    end
    redirect_to dashboard_index_path
  end

  def filter
    #params to array
    columns = params[:filter_selected_id].split(',')
    unless columns.empty?
      UserFilterColumn.transaction do
        # defaults
        default_filter = DefaultFilter.where(:table_name => 'matters_deadlines').first
        UserFilter.create_modified current_user, default_filter, columns
      end
    end
    redirect_to dashboard_index_path
  end

  private

  def show_column_filter
    @apply_filter = true
    default_filter = DefaultFilter.where(:table_name => 'matters_deadlines').first
    @columns = DefaultFilterColumn.where(:default_filter_id => default_filter.id).all
    #
    filter = UserFilter.where(:user_id => current_user.id, :table_name => 'matters_deadlines').first
    if filter.nil?
      filter = default_filter
    end
    @chosen_columns = UserFilterColumn.where(:user_filter_id => filter.id ).all
    if @chosen_columns.empty?
      @chosen_columns = DefaultFilterColumn.where(:default_filter_id => filter.id, :is_default => true).all
    end
  end

  def get_message id
    if id.nil?
      return Message.last
    end
    return Message.find(id)
  rescue ActiveRecord::RecordNotFound
    flash.now[:error] = "Message not found! Showing last."
    return Message.last
  end

end
