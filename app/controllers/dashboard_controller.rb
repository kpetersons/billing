class DashboardController < ApplicationController

  layout "dashboard"

  before_filter :show_column_filter, :only => [:show, :message, :find]

  def show
    ids = VMatterTasks.all.collect { |x| x.matter_id }.uniq
    @matter_tasks = VMatterTasks.order(tasks_order_clause).paginate(:per_page => current_user.rows_per_page, :page => params[:matter_tasks])
    @recent_activity_matters = VMatters.where("updated_at between ? and ?", Date.today-5, Date.today+1).order(matters_order_clause).paginate(:per_page => current_user.rows_per_page, :page => params[:recent_activity_page])
    @upcoming_deadlines_matters = VMatters.where(:id => ids).order(matters_order_clause).paginate(:per_page => current_user.rows_per_page, :page => params[:upcoming_deadlines_page])

    @message = Message.last
    @direction = (@direction.eql?("ASC")) ? "DESC" : "ASC"
  end

  def message
    ids = VMatterTasks.all.collect { |x| x.matter_id }.uniq
    @matter_tasks = VMatterTasks.order(tasks_order_clause).paginate(:per_page => current_user.rows_per_page, :page => params[:matter_tasks])
    @recent_activity_matters = VMatters.where("updated_at between ? and ?", Date.today-5, Date.today+1).order(matters_order_clause).paginate(:per_page => current_user.rows_per_page, :page => params[:recent_activity_page])
    @upcoming_deadlines_matters = VMatters.where(:id => ids).order(matters_order_clause).paginate(:per_page => current_user.rows_per_page, :page => params[:upcoming_deadlines_page])
    @direction = (@direction.eql?("ASC")) ? "DESC" : "ASC"
    render 'show'
  end

  def find
    ids = VMatterTasks.all.collect { |x| x.matter_id }.uniq
    begin
      @from = Date.strptime(params[:from], '%d.%m.%Y')
    rescue
      @from = Date.strptime('01.01.1990', '%d.%m.%Y')
      from_bkp = true
    end
    begin
      @to = Date.strptime(params[:to], '%d.%m.%Y')
    rescue
      @to = Date.strptime('01.01.3000', '%d.%m.%Y')
      to_bkp = true
    end
    @task_type = (params[:task_type].eql? "ALL") ? MatterTaskType.all.collect { |x| x.name } : params[:task_type]
    @matter_type = (params[:matter_type].eql? "matters.all") ? MatterType.all.collect { |x| x.name } : params[:matter_type]
    @task_status = (params[:task_status].eql? "matters.task.status.all") ? MatterTaskStatus.all.collect { |x| x.name } : params[:task_status]
    @description = params[:description]
    @query = VMatterTasks.where(:task_type => @task_type, :matter_type => @matter_type, :status => @task_status).where("deadline between ? and ? and description ilike ?", @from.to_s(:db), @to.to_s(:db), "%#{@description}%")
    @matter_tasks = @query.order(tasks_order_clause).paginate(:per_page => current_user.rows_per_page, :page => params[:param_name])
    @message = get_message params[:id]
    if from_bkp
      @from = nil
    end
    if to_bkp
      @to = nil
    end
    @matter_type = params[:matter_type]
    @task_type = params[:task_type]
    @task_status = params[:task_status]
    @matter_tasks = VMatterTasks.order(matters_order_clause).paginate(:per_page => current_user.rows_per_page, :page => params[:matter_tasks])
    @recent_activity_matters = VMatters.where("updated_at between ? and ?", Date.today-5, Date.today+1).order(matters_order_clause).paginate(:per_page => current_user.rows_per_page, :page => params[:recent_activity_page])
    @upcoming_deadlines_matters = VMatters.where(:id => ids).order(matters_order_clause).paginate(:per_page => current_user.rows_per_page, :page => params[:upcoming_deadlines_page])

    @direction = (@direction.eql?("ASC")) ? "DESC" : "ASC"
    render 'show'
  end

  def reset
    UserFilterColumn.transaction do
      UserFilter.reset_filter current_user, 'dashboard'
    end
    redirect_to dashboard_index_path
  end

  def clear
    UserFilterColumn.transaction do
      UserFilter.clear_filter current_user, 'dashboard'
    end
    redirect_to dashboard_index_path
  end

  def filter
    #params to array
    columns = params[:filter_selected_id].split(',')
    unless columns.empty?
      UserFilterColumn.transaction do
        # defaults
        default_filter = DefaultFilter.where(:table_name => 'dashboard').first
        UserFilter.create_modified current_user, default_filter, columns
      end
    end
    redirect_to dashboard_index_path
  end

  private

  def tasks_order_clause
    unless params[:tasks].nil?
      order_by = params[:tasks][:order_by]
      direction = params[:tasks][:direction]
      "#{order_by} #{direction}"
    end
  end

  def matters_order_clause
    order_by = params[:order_by]
    direction = params[:direction]
    "#{order_by} #{direction}"
  end

  def show_column_filter
    @parameters = Marshal.load(Marshal.dump(params))
    @parameters.delete_if { |k, v| k.eql? "direction" }
    @parameters.delete_if { |k, v| k.eql? "order_by" }

    if params[:tasks]
      @order_tasks = true
    else
      @order_tasks = false
    end
    @apply_filter = true
    default_filter = DefaultFilter.where(:table_name => 'dashboard').first
    @columns = DefaultFilterColumn.where(:default_filter_id => default_filter.id).all
    #
    filter = UserFilter.where(:user_id => current_user.id, :table_name => 'dashboard').first
    if filter.nil?
      filter = default_filter
    end
    @chosen_columns = UserFilterColumn.where(:user_filter_id => filter.id).all
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
