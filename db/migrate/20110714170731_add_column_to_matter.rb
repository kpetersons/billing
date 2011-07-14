class AddColumnToMatter < ActiveRecord::Migration
  def self.up
		add_column :matters, :status_id, :integer
  end

  def self.down
		remove_column :matters, :status_id
  end
end
