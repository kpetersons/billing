class AddColumnsToMatterTaskStatuss < ActiveRecord::Migration
  def self.up
		add_column :matter_task_statuses, :revert_to_name, :string
		add_column :matter_task_statuses, :pass_to_name, :string
  end

  def self.down
		remove_column :matter_task_statuses, :pass_to_name
		remove_column :matter_task_statuses, :revert_to_name
  end
end
