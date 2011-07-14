class AddColumnInvoiceLine < ActiveRecord::Migration
  def self.up
		add_column :invoice_lines, :units, :integer, :limit => 1.byte
  end

  def self.down
		remove_column :invoice_lines, :units
  end
end
