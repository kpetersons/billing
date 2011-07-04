class RenameColumnToInvoiceLine < ActiveRecord::Migration
		rename_column :invoice_lines, :attorneys_fee, :attorney_fee
		rename_column :invoice_lines, :off_fee, :official_fee		
  def self.up
  end

  def self.down
		rename_column :invoice_lines, :attorney_fee, :attorneys_fee
    rename_column :invoice_lines, :official_fee, :off_fee		
  end
end
