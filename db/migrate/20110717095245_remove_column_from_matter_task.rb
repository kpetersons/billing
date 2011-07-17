class RemoveColumnFromMatterTask < ActiveRecord::Migration
  def self.up
    remove_column :matter_tasks, :matter_task_status_flow_id
  end

  def self.down
    add_column :matter_tasks, :matter_task_status_flow_id, :integer    
  end
end
