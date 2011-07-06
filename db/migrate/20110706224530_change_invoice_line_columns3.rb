class ChangeInvoiceLineColumns3 < ActiveRecord::Migration
  def self.up
   remove_column :invoice_lines, :official_fee
   remove_column :invoice_lines, :attorney_fee    
   add_column :invoice_lines, :official_fee, :decimal, :precision => 8, :scale => 2
   add_column :invoice_lines, :attorney_fee, :decimal, :precision => 8, :scale => 2    
  end

  def self.down

  end
end
