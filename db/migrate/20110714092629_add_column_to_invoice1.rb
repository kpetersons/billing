class AddColumnToInvoice1 < ActiveRecord::Migration
  def self.up
		add_column :invoices, :subject, :string, :limit => 2000 
		add_column :invoices, :ending_details, :string, :limit => 2000
		add_column :invoices, :payment_term, :integer, :limit => 1.byte
		add_column :invoices, :apply_vat, :boolean
  end

  def self.down
		remove_column :invoices, :payment_term
		remove_column :invoices, :subject
    remove_column :invoices, :ending_details
    remove_column :invoices, :apply_vat		
  end
end
