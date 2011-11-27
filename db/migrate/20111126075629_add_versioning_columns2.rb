class AddVersioningColumns2 < ActiveRecord::Migration
  def self.up
    add_column :matters, :date_effective_end, :datetime
    #
    add_column :addresses, :date_effective_end, :datetime
    #
    add_column :customers, :date_effective_end, :datetime
  end

  def self.down
  end
end
