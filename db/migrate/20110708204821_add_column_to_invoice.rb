class AddColumnToInvoice < ActiveRecord::Migration
  def self.up
		add_column :invoices, :exchange_rate, :decimal, :precision => 7, :scale => 4
  end

  def self.down
		remove_column :invoices, :exchange_rate
  end
end
