class MatterTasksController < ApplicationController
  layout "matters"
  def index
    @matter_tasks = MatterTask.all
  end

  def new
    @matter_task = MatterTask.new(:matter_id => params[:matter_id], :matter_task_status_id => MatterTaskStatus.find_by_name('matter.task.status.open').id)
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

end
