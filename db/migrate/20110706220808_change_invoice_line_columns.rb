class ChangeInvoiceLineColumns < ActiveRecord::Migration
  def self.up
		change_column :invoice_lines, :offering, :text
    change_column :invoice_lines, :details, :text
  end

  def self.down

  end
end
