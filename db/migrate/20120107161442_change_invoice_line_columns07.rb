class ChangeInvoiceLineColumns07 < ActiveRecord::Migration
  def up
    change_column :invoice_lines, :offering, :text
    change_column :invoice_lines, :details, :text
  end

  def down
  end
end
