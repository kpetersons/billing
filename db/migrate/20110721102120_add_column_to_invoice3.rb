class AddColumnToInvoice3 < ActiveRecord::Migration
  def self.up
		add_column :invoices, :date_paid, :date
  end

  def self.down
		remove_column :invoices, :date_paid
  end
end
