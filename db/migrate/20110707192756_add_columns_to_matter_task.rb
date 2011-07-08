class AddColumnsToMatterTask < ActiveRecord::Migration
  def self.up
		add_column :matter_tasks, :matter_type_status_flow_id, :integer
  end

  def self.down
		remove_column :matter_tasks, :matter_type_status_flow_id
  end
end
