class CreateUserFilterColumns < ActiveRecord::Migration
  def self.up
    create_table :user_filter_columns do |t|
      t.references :user_filter      
      t.string  :column_name
      t.string  :column_type
      t.string  :column_query
      t.integer :column_position
      
      t.timestamps
    end
  end

  def self.down
    drop_table :user_filter_columns
  end
end
