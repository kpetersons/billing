class AddColumnToDefaultFilterColumn < ActiveRecord::Migration
  def self.up
    add_column :default_filter_columns, :default_filter_id, :integer
  end

  def self.down
  end
end
