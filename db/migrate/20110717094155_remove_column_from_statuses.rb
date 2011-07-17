class RemoveColumnFromStatuses < ActiveRecord::Migration
  def self.up
    remove_column :matter_task_statuses, :revert_to_name
    remove_column :matter_task_statuses, :pass_to_name
    remove_column :matter_statuses, :revert_to_name
    remove_column :matter_statuses, :pass_to_name
    remove_column :invoice_statuses, :revert_to_name
    remove_column :invoice_statuses, :pass_to_name
  end

  def self.down
  end
end
