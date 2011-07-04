class RenameColumnInvoiceLinePreset2 < ActiveRecord::Migration
  def self.up
		rename_column :invoice_line_presets, :attorneys_fee, :attorney_fee
		rename_column :invoice_line_presets, :off_fee, :official_fee
  end

  def self.down
		rename_column :invoice_line_presets, :attorney_fee, :attorneys_fee
    rename_column :invoice_line_presets, :official_fee, :off_fee		
  end
end
