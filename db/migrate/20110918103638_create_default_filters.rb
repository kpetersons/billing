class CreateDefaultFilters < ActiveRecord::Migration
  def self.up
    create_table :default_filters do |t|
      t.string :table_name

      t.timestamps
    end
  end

  def self.down
    drop_table :default_filters
  end
end
