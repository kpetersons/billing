class AddTypeToInvoice2 < ActiveRecord::Migration
  def self.up
    remove_column :invoices, :type    
    add_column :invoices, :invoice_type, :integer
  end

  def self.down
    add_column :invoices, :type, :integer
    remove_column :invoices, :invoice_type
  end
end
