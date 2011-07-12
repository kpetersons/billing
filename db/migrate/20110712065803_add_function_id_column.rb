class AddFunctionIdColumn < ActiveRecord::Migration
  def self.up
		add_column :matter_task_statuses, :function_id, :integer
		add_column :matter_task_status_flows, :function_id, :integer
  end

  def self.down
		remove_column :matter_task_status_flows, :function_id
		remove_column :matter_task_statuses, :function_id
  end
end
