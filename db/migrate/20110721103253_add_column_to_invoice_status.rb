class AddColumnToInvoiceStatus < ActiveRecord::Migration
  def self.up
		add_column :invoice_statuses, :editable_state, :boolean
  end

  def self.down
		remove_column :invoice_statuses, :editable_state
  end
end
