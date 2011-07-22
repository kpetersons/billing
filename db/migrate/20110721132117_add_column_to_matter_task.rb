class AddColumnToMatterTask < ActiveRecord::Migration
  def self.up
		add_column :matter_tasks, :matter_task_type_id, :integer
  end

  def self.down
		remove_column :matter_tasks, :matter_task_type_id
  end
end
