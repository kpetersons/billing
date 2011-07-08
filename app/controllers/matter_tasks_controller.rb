class MatterTasksController < ApplicationController
  layout "matters"
  def index
    @matter_tasks = MatterTask.all
  end

  def new
    @matter_task = MatterTask.new(
    :matter_id => params[:matter_id],
    :matter_task_status_id => MatterTaskStatusFlow.where(:start_state => true).first.current_step.id,
    :matter_task_status_flow_id => MatterTaskStatusFlow.where(:start_state => true).first.id,
    :author_id => current_user.id
    )
  end

  def create
    MatterTask.transaction do
      @matter_task = MatterTask.new(params[:matter_task])
      if @matter_task.save
        redirect_to matter_path(@matter_task.matter)
      else
        render 'new'
      end
    end
  end

  def edit
    @matter_task = MatterTask.find(params[:id])
  end

  def update
    @matter_task = MatterTask.find(params[:matter_task][:id])
    MatterTask.transaction do
      if @matter_task.update_attributes(params[:matter_task])
        @matter = @matter_task.matter
        redirect_to matter_path(@matter)
      else
        render 'edit'
      end
    end
  end

  def show
    @matter_task = MatterTask.find(params[:id])
  end

  def flow
    @matter_task = MatterTask.find(params[:id])
    @matter_task_status = MatterTaskStatus.find(params[:status])
    MatterTask.transaction do
      if @matter_task.update_attribute(:matter_task_status_id, @matter_task_status.id)
        puts "MatterTaskStatusFlow.where(:current_step_id => @matter_task_status.id).first #{MatterTaskStatusFlow.where(:current_step_id => @matter_task_status.id).first.id}"
        if @matter_task.update_attribute(:matter_task_status_flow_id, MatterTaskStatusFlow.where(:current_step_id => @matter_task_status.id).first.id)
          flash[:success] = t("matter.task.status.change.success")
          redirect_to matter_path(@matter_task.matter, :anchor => :tasks)
        else
          flash[:error] = t("matter.task.status.change.failed")
          redirect_to matter_path(@matter_task.matter)
        end
      else
        flash[:error] = t("matter.task.status.change.failed")
        redirect_to matter_path(@matter_task.matter)
      end
    end
  end
end
