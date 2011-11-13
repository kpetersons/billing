class ChangeQuantityDecimalPrecision < ActiveRecord::Migration
  def self.up
    change_column :invoice_lines, :items, :decimal, :precision => 10, :scale => 2
  end

  def self.down
  end
end
