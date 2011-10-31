class AddColumnToInvoiceLinesDiscount < ActiveRecord::Migration
  def self.up
    add_column :invoice_lines, :total_discount, :decimal, :precision => 10, :scale => 2
  end

  def self.down
  end
end
