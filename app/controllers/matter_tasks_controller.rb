class MatterTasksController < ApplicationController
  layout "matters"
  def index
    @matter_tasks = MatterTask.all
  end

  def new
    @matter_task = MatterTask.new(
    :matter_id => params[:matter_id],
    :matter_task_status_id => MatterTaskStatus.first.id,
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
    @matter = Matter.find(params[:matter_id])
    @matter_task = MatterTask.find(params[:id])    
    MatterTask.transaction do
      if @matter_task.update_attribute(:matter_task_status_id, params[:matter_task_status][:id])
        redirect_to matter_task_path(@matter, @matter_task) and return
      else
        redirect_to matter_task_path(@matter, @matter_task) and return
      end
    end
  end

end
