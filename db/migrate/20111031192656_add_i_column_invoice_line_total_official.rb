class AddIColumnInvoiceLineTotalOfficial < ActiveRecord::Migration
  def self.up

    add_column :invoice_lines, :total_attorney_fee, :decimal, :precision => 10, :scale => 2
    add_column :invoice_lines, :total_official_fee, :decimal, :precision => 10, :scale => 2

  end

  def self.down
  end
end
