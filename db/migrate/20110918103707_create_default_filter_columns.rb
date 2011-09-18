class CreateDefaultFilterColumns < ActiveRecord::Migration
  def self.up
    create_table :default_filter_columns do |t|
      t.string  :column_name
      t.string  :column_type
      t.string  :column_query
      t.integer :column_position

      t.timestamps
    end
  end

  def self.down
    drop_table :default_filter_columns
  end
end
