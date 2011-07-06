class ChangeInvoiceLineColumns < ActiveRecord::Migration
  def self.up
#		change_column :invoice_lines, :official_fee, :decimal, :precision => 8, :scale => 2
#    change_column :invoice_lines, :attorney_fee, :decimal, :precision => 8, :scale => 2
  end

  def self.down
		change_column :invoice_lines, :official_fee, :string
		change_column :invoice_lines, :attorney_fee, :string
  end
end
