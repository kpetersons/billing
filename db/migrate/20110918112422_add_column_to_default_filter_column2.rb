class AddColumnToDefaultFilterColumn2 < ActiveRecord::Migration
  def self.up
    add_column :default_filter_columns, :is_default, :boolean    
  end

  def self.down
  end
end
