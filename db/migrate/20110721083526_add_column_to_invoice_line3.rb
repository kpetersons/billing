class AddColumnToInvoiceLine3 < ActiveRecord::Migration
  def self.up
		add_column :invoice_lines, :items, :integer
		remove_column :invoice_lines, :units
		add_column :invoice_lines, :units, :string
  end

  def self.down
		remove_column :invoice_lines, :units
		remove_column :invoice_lines, :column_name
  end
end
