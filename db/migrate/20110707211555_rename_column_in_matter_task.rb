class RenameColumnInMatterTask < ActiveRecord::Migration
  def self.up
		rename_column :matter_tasks, :matter_type_status_flow_id, :matter_task_status_flow_id
  end

  def self.down
		rename_column :matter_tasks, :matter_task_status_flow_id, :matter_type_statuss_flow_id
		
  end
end
