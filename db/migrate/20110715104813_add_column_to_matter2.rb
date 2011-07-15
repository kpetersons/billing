class AddColumnToMatter2 < ActiveRecord::Migration
  def self.up
    add_column :matters, :matter_status_id, :integer
    remove_column :matters, :status_id
  end

  def self.down
    add_column :matters, :status_id, :string
    remove_column :matters, :matter_status_id
  end
end
