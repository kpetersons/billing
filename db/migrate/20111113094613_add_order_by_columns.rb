class AddOrderByColumns < ActiveRecord::Migration
  def self.up
    add_column :default_filter_columns, :column_order_query, :string
    add_column :user_filter_columns, :column_order_query, :string
  end

  def self.down
  end
end
