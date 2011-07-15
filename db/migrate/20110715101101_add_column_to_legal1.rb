class AddColumnToLegal1 < ActiveRecord::Migration
  def self.up
		add_column :legals, :legal_type_id, :integer
		remove_column :legals, :type
  end

  def self.down
		remove_column :table_name, :column_name
		add_column :legals, :type, :integer	
  end
end
