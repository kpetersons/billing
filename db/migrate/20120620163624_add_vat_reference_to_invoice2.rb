class AddVatReferenceToInvoice2 < ActiveRecord::Migration
  def change
    change_table :invoices do |t|
      t.references :billing_settings
    end
  end
end
