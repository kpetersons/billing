class AddTranslateableToFilterColumns < ActiveRecord::Migration
  def self.up
    add_column :default_filter_columns, :translate, :boolean, :default => false
    add_column :user_filter_columns, :translate, :boolean, :default => false
  end

  def self.down
  end
end
