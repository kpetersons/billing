class RenameColumnInvoiceLinePreset < ActiveRecord::Migration
  def self.up
		rename_column :invoice_line_presets, :attorneys_fee_type_id, :attorney_fee_type_id
  end

  def self.down
		rename_column :invoice_line_presets, :attorney_fee_type_id, :attorneys_fee_type_id
  end
end
