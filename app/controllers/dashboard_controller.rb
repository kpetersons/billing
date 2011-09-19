class DashboardController < ApplicationController

  layout "dashboard"

  before_filter :show_column_filter, :only => :show

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
      filter = UserFilter.where(:user_id => current_user.id, :table_name => 'matters_deadlines').first
      unless filter.nil?
        UserFilterColumn.delete(UserFilterColumn.where(:user_filter_id => filter.id).all)
      end
    end
    redirect_to dashboard_index_path
  end

  def filter
    UserFilterColumn.transaction do
      columns = params[:filter_selected_id].split(',')
      unless columns.empty?
        filter = UserFilter.where(:user_id => current_user.id, :table_name => 'matters_deadlines').first
        if filter.nil?
          filter = UserFilter.new(:user_id => current_user.id, :table_name => 'matters_deadlines')
          filter.save
        end
        default_filter = DefaultFilter.where(:table_name => 'matters_deadlines').first
        UserFilterColumn.delete(UserFilterColumn.where(:user_filter_id => filter.id).all)
        columns.each do |column|
          default_column = DefaultFilterColumn.where(:column_query => column, :default_filter_id => default_filter.id).first
          UserFilterColumn.new(
            :user_filter_id => filter.id,
            :column_name => default_column.column_name,
            :column_type => default_column.column_type,
            :column_query => default_column.column_query,
            :column_position => default_column.column_position).save
        end
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
