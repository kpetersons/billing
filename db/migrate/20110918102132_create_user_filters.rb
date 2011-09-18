class CreateUserFilters < ActiveRecord::Migration
  def self.up
    create_table :user_filters do |t|
      t.references :user      
      t.string :table_name

      t.timestamps
    end
  end

  def self.down
    drop_table :user_filters
  end
end
