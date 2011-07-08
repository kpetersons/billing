class AddColumnsToMatterTaskStatusFlow < ActiveRecord::Migration
  def self.up    
		add_column :matter_type_statuss_flows, :start_state, :boolean, :default => false
		rename_table :matter_type_statuss_flows, :matter_task_status_flows
  end

  def self.down
		rename_table :matter_task_statuss_flows, :matter_type_status_flows
		remove_column :matter_type_statuss_flows, :start_state
  end
end
