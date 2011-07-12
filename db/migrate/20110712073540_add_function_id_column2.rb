class AddFunctionIdColumn2 < ActiveRecord::Migration
  def self.up
    remove_column :matter_task_statuses, :function_id
		add_column :matter_types, :function_id, :integer
    remove_column :matter_task_status_flows, :function_id
		add_column :matter_task_status_flows, :pass_to_function_id, :integer
		add_column :matter_task_status_flows, :revert_to_function_id, :integer
  end

  def self.down
		remove_column :table_name, :column_name
		remove_column :matter_task_status_flows, :pass_to_function_id
    remove_column :matter_task_status_flows, :revert_to_function_id		
		remove_column :matter_types, :function_id
  end
end
