class CreateInvoiceLinePresets < ActiveRecord::Migration
  def self.up
    create_table :invoice_line_presets do |t|
      t.references :operating_party
      t.references :official_fee_type
      t.references :attorneys_fee_type
      t.string :name
      t.string :off_fee
      t.string :attorneys_fee

      t.timestamps
    end
  end

  def self.down
    drop_table :invoice_line_presets
  end
end
