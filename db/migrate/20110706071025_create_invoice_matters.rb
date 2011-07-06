class CreateInvoiceMatters < ActiveRecord::Migration
  def self.up
    create_table :invoice_matters do |t|
      t.references :invoice
      t.references :matter
      t.references :matter_task

      t.timestamps
    end
  end

  def self.down
    drop_table :invoice_matters
  end
end
