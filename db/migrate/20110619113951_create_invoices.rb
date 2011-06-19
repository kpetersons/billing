class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.references :document
      t.references :customer
      t.references :address
      t.references :individual
      t.references :currency
      t.references :exchange_rate
      t.integer :discount
      t.string :our_ref
      t.string :your_ref
      t.date :your_date
      t.string :po_billing
      t.string  :finishing_details
      t.date :invoice_date
      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
