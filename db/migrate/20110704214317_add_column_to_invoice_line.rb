class AddColumnToInvoiceLine < ActiveRecord::Migration
  def self.up
		add_column :invoice_lines, :attorney_fee_type_id, :integer
  end

  def self.down
		remove_column :invoice_lines, :attorney_fee_type_id
  end
end
