class AddColumnToInvoiceLine2 < ActiveRecord::Migration
  def self.up
		add_column :invoice_lines, :offering, :string
  end

  def self.down
		remove_column :invoice_lines, :offering
  end
end
