class AddVersioningColumns3 < ActiveRecord::Migration
  def self.up
    add_column :parties, :version, :integer, :default => 1
    add_column :parties, :orig_id, :integer
    add_column :parties, :date_effective, :datetime
    add_column :parties, :date_effective_end, :datetime
    #
    add_column :companies, :version, :integer, :default => 1
    add_column :companies, :orig_id, :integer
    add_column :companies, :date_effective, :datetime
    add_column :companies, :date_effective_end, :datetime
  end

  def self.down
  end
end

