class DashboardController < ApplicationController

  layout "dashboard"

  before_filter :show_column_filter, :only => [:show, :message, :find]

  def show
    @matter_tasks = VMatterTasks.paginate(:page => params[:matter_tasks])
    @recent_activity_matters = VMatters.where("updated_at between ? and ?", Date.today-5, Date.today+1).paginate(:page => params[:recent_activity_page])
    ids = VMatterTasks.all.collect {|x| x.matter_id}.uniq
    @upcoming_deadlines_matters = VMatters.where(:id => ids).paginate(:page => params[:upcoming_deadlines_page])
    @message = Message.last

  end

  def message
    @matter_tasks = VMatterTasks.paginate(:page => params[:param_name])
    @recent_activity_matters = VMatters.where("updated_at between ? and ?", Date.today-5, Date.today+1).paginate(:page => params[:param_name])
    ids = VMatterTasks.all.collect {|x| x.matter_id}.uniq
    @upcoming_deadlines_matters = VMatters.where(:id => ids).paginate(:page => params[:param_name])
    @message = get_message params[:id]
    render 'show'
  end

  def find
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
    @task_type =  (params[:task_type].eql?"ALL")? MatterTaskType.all.collect{|x| x.name} : params[:task_type]
    @matter_type = (params[:matter_type].eql?"matters.all")? MatterType.all.collect{|x| x.name} : params[:matter_type]
    @task_status = (params[:task_status].eql?"matters.task.status.all")? MatterTaskStatus.all.collect{|x| x.name} : params[:task_status]
    @description = params[:description]
    @query = VMatterTasks.where(:task_type => @task_type, :matter_type => @matter_type, :status => @task_status).where("deadline between ? and ? and description ilike ?", @from.to_s(:db), @to.to_s(:db), "%#{@description}%")
    @matter_tasks = @query.paginate(:page => params[:param_name])
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
    @recent_activity_matters = VMatters.where("updated_at between ? and ?", Date.today-5, Date.today+1).paginate(:page => params[:param_name])
    @upcoming_deadlines_matters = VMatters.where(:id => @query.all.collect {|x| x.matter_id}.uniq).paginate(:page => params[:param_name])
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

  def show_column_filter
    @apply_filter = true
    default_filter = DefaultFilter.where(:table_name => 'dashboard').first
    @columns = DefaultFilterColumn.where(:default_filter_id => default_filter.id).all
    #
    filter = UserFilter.where(:user_id => current_user.id, :table_name => 'matters_deadlines').first
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
