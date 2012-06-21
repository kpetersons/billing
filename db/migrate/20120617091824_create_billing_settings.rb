class CreateBillingSettings < ActiveRecord::Migration
  def change
    create_table :billing_settings do |t|
      t.decimal :vat_rate, :precision => 8, :scale => 2
      t.boolean :active
      t.timestamps
    end
  end
end
