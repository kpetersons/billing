class AddVersioningColumns4 < ActiveRecord::Migration
  def self.up
    add_column :documents, :version, :integer, :default => 1
    add_column :documents, :orig_id, :integer
    add_column :documents, :date_effective, :datetime
    add_column :documents, :date_effective_end, :datetime
  end

  def self.down
  end
end
