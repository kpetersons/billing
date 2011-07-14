class AddColumnToInvoice2 < ActiveRecord::Migration
  def self.up
		add_column :invoices, :invoice_status_id, :integer
  end

  def self.down
		remove_column :invoices, :invoice_status_id
  end
end
