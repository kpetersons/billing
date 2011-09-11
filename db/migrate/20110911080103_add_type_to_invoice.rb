class AddTypeToInvoice < ActiveRecord::Migration
  def self.up
    add_column :invoices, :type, :integer
  end

  def self.down
    remove_column :invoices, :type
  end
end
