class AddForeignNumberToInvoice < ActiveRecord::Migration
  def self.up
    add_column :invoices, :foreign_number, :integer
    add_column :invoices, :local_number, :integer    
  end

  def self.down
    remove_column :invoices, :foreign_number
    remove_column :invoices, :local_number    
  end
end
