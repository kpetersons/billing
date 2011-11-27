class AddVersioningColumns1 < ActiveRecord::Migration
  def self.up
    add_column :matters, :version, :integer
    add_column :matters, :orig_id, :integer
    add_column :matters, :date_effective, :datetime
    #
    add_column :addresses, :version, :integer
    add_column :addresses, :orig_id, :integer
    add_column :addresses, :date_effective, :datetime
    #
    add_column :customers, :version, :integer
    add_column :customers, :orig_id, :integer
    add_column :customers, :date_effective, :datetime
  end

  def self.down
  end
end
