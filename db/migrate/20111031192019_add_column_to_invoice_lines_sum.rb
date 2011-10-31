class AddColumnToInvoiceLinesSum < ActiveRecord::Migration
  def self.up
    add_column :invoice_lines, :total, :decimal, :precision => 10, :scale => 2
  end

  def self.down
  end
end
