class AddColumnToStatuses < ActiveRecord::Migration
  def self.up
    add_column :invoice_statuses, :function_id, :integer    
    add_column :matter_statuses, :function_id, :integer    
		add_column :matter_task_statuses, :function_id, :integer
		
  end

  def self.down
    remove_column :invoice_statuses, :function_id    
    remove_column :matter_statuses, :function_id    
    remove_column :matter_task_statuses, :function_id
  end
end
