class AddVatReferenceToInvoice < ActiveRecord::Migration
  def change
    change_table :invoice_lines do |t|
      t.references :billing_settings
    end
  end
end
