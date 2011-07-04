class CreateInvoiceLines < ActiveRecord::Migration
  def self.up
    create_table :invoice_lines do |t|
      t.references :invoice
      t.references :official_fee_type
      t.references :official_fee_type
      t.string :off_fee
      t.string :attorneys_fee
      t.string :details

      t.timestamps
    end
  end

  def self.down
    drop_table :invoice_lines
  end
end
